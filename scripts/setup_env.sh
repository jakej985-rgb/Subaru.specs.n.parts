#!/bin/bash
set -e

# Define installation path
INSTALL_DIR="$HOME/flutter"
RC_FILE="$HOME/.bashrc"

# Check if flutter is already in PATH
if command -v flutter &> /dev/null; then
    echo "Flutter is already in PATH."
    flutter --version
    exit 0
fi

# Check if installed but not in PATH
if [ -d "$INSTALL_DIR" ]; then
    echo "Flutter found in $INSTALL_DIR but not in PATH."
else
    echo "Installing Flutter to $INSTALL_DIR..."
    # Cloning with depth 1 to save time/bandwidth
    git clone --depth 1 https://github.com/flutter/flutter.git -b stable "$INSTALL_DIR"

    # Precache
    export PATH="$PATH:$INSTALL_DIR/bin"
    echo "Running flutter precache..."
    flutter precache
fi

# Persist to RC file if not already present
if ! grep -q "$INSTALL_DIR/bin" "$RC_FILE"; then
    echo "Adding Flutter to $RC_FILE..."
    echo "" >> "$RC_FILE"
    echo "# Flutter SDK" >> "$RC_FILE"
    echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$RC_FILE"
    echo "Successfully added to $RC_FILE."
else
    echo "Flutter path already in $RC_FILE."
fi

echo "Setup complete."
echo "Please run: source $RC_FILE"
echo "Then verify with: flutter --version"
