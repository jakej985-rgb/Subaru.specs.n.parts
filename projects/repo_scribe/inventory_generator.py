import os
import csv
import json
import subprocess
import fnmatch

ARTIFACTS_DIR = 'projects/repo_scribe/artifacts'

# Specific ignored folders we MUST capture per requirements
IGNORED_ROOTS = ['build', '.dart_tool', '.idea', 'android/.gradle', 'ios/Pods']

def get_tracked_files():
    """Returns a set of files tracked by git."""
    try:
        output = subprocess.check_output(['git', 'ls-files'], universal_newlines=True)
        return set(output.strip().splitlines())
    except subprocess.CalledProcessError:
        print("Warning: git ls-files failed. Assuming no tracked files.")
        return set()

def get_all_workspace_items(root_dir='.'):
    """
    Returns a list of all files and directories in the workspace,
    including ignored ones.
    """
    all_items = []

    # Walk the tree
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # normalize path separator
        dirpath = dirpath.replace('\\', '/')
        if dirpath.startswith('./'):
            dirpath = dirpath[2:]
        elif dirpath == '.':
            dirpath = ''

        # Skip .git directory
        if '.git' in dirnames:
            dirnames.remove('.git')

        # Add directories
        for d in dirnames:
            full_path = os.path.join(dirpath, d) if dirpath else d
            all_items.append(full_path.replace('\\', '/'))

        # Add files
        for f in filenames:
            full_path = os.path.join(dirpath, f) if dirpath else f
            all_items.append(full_path.replace('\\', '/'))

    # Explicitly check for required ignored folders if they weren't found by walk
    # (e.g. if they are missing, we can't inventory them as "present", but
    # if they are present, walk should have found them unless we filtered them)
    # The walk above does not filter ignored files.

    return sorted(all_items)

def is_ignored(path):
    """Checks if a path is ignored by git."""
    try:
        subprocess.check_output(['git', 'check-ignore', '-q', path])
        return True
    except subprocess.CalledProcessError:
        return False

def classify_item(path, is_tracked, is_ignored_status):
    kind = 'dir' if os.path.isdir(path) else 'file'

    if is_tracked:
        status = 'tracked'
    elif is_ignored_status:
        status = 'ignored'
    else:
        status = 'untracked'

    # Determine Type
    ext = os.path.splitext(path)[1].lower()
    if any(path.startswith(x) for x in ['build/', '.dart_tool/']) or '.g.dart' in path:
        item_type = 'generated'
    elif ext == '.dart':
        item_type = 'dart'
    elif ext in ['.yaml', '.json', '.xml', '.properties', '.gradle', '.plist']:
        item_type = 'config'
    elif ext in ['.py', '.sh', '.bat']:
        item_type = 'script'
    elif ext in ['.png', '.jpg', '.jpeg', '.svg', '.ttf', '.ico']:
        item_type = 'asset'
    elif ext == '.md':
        item_type = 'docs'
    elif 'test' in path:
        item_type = 'test'
    else:
        item_type = 'unknown'

    # Determine Role
    if 'test/' in path or '_test.dart' in path:
        role = 'test'
    elif 'lib/' in path:
        if 'router' in path:
            role = 'routing'
        elif 'provider' in path or 'riverpod' in path:
            role = 'state'
        elif 'ui' in path or 'screen' in path or 'widget' in path:
            role = 'ui'
        elif 'data' in path or 'model' in path or 'database' in path:
            role = 'data'
        elif 'main.dart' in path or 'app.dart' in path:
            role = 'core'
        else:
            role = 'app'
    elif 'assets/' in path:
        role = 'asset'
    elif 'tool/' in path or 'scripts/' in path:
        role = 'tooling'
    elif '.github/' in path:
        role = 'CI'
    elif 'docs/' in path or '.md' in path:
        role = 'docs'
    elif any(path.startswith(x) for x in ['build/', '.dart_tool/']):
        role = 'generated'
    else:
        role = 'config'

    # Refine Purpose and Confidence
    purpose = "Unknown; needs review"
    confidence = 5
    notes = ""

    if role == 'generated':
        purpose = "Generated artifact (build output or cache)"
        confidence = 10
        notes = "Do not edit manually."
    elif 'main.dart' in path:
        purpose = "App entry point"
        confidence = 10
    elif 'app_router.dart' in path:
        purpose = "Routing configuration"
        confidence = 10
    elif 'pubspec.yaml' in path:
        purpose = "Dart package dependencies and configuration"
        confidence = 10
    elif 'README.md' in path:
        purpose = "Project overview and documentation"
        confidence = 10
    elif 'sync_fitment_csv_to_specs_json.py' in path:
        purpose = "Syncs CSV fitment data to JSON specs (CI check)"
        confidence = 10
        notes = "Critical CI script"
    elif 'assets/seed/specs' in path and ext == '.json':
        purpose = "Specification seed data"
        confidence = 9
    elif 'lib/data/database' in path and ext == '.dart':
        purpose = "Drift database definition"
        confidence = 8

    return {
        'path': path,
        'kind': kind,
        'status': status,
        'type': item_type,
        'role': role,
        'purpose': purpose,
        'confidence': confidence,
        'notes': notes
    }

def main():
    print("Gathering tracked files...")
    tracked = get_tracked_files()

    print("Crawling workspace...")
    all_paths = get_all_workspace_items()

    inventory = []

    print(f"Processing {len(all_paths)} items...")
    for path in all_paths:
        is_tracked_file = path in tracked
        # Only check ignore status for non-tracked files to save time,
        # unless it's a directory (directories aren't in 'tracked' usually)
        if is_tracked_file:
            ignored_status = False
        else:
            ignored_status = is_ignored(path)

        item = classify_item(path, is_tracked_file, ignored_status)
        inventory.append(item)

    # Ensure artifacts directory exists
    os.makedirs(ARTIFACTS_DIR, exist_ok=True)

    # Save to JSON
    json_path = os.path.join(ARTIFACTS_DIR, 'inventory.json')
    with open(json_path, 'w') as f:
        json.dump(inventory, f, indent=2)
    print(f"Inventory JSON written to {json_path}")

    # Save to CSV
    csv_path = os.path.join(ARTIFACTS_DIR, 'inventory.csv')
    with open(csv_path, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['path', 'status', 'kind', 'type', 'role', 'purpose', 'confidence', 'notes'])
        writer.writeheader()
        for item in inventory:
            writer.writerow(item)
    print(f"Inventory CSV written to {csv_path}")

if __name__ == '__main__':
    main()
