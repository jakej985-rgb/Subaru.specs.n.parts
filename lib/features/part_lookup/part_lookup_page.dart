import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';

class PartLookupPage extends ConsumerStatefulWidget {
  const PartLookupPage({super.key});

  @override
  ConsumerState<PartLookupPage> createState() => _PartLookupPageState();
}

class _PartLookupPageState extends ConsumerState<PartLookupPage> {
  String _query = '';
  List<Part> _results = [];

  void _search(String query) async {
    setState(() => _query = query);
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final db = ref.read(appDbProvider);
    final results = await db.partsDao.searchParts(query);
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Part Lookup')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Name or OEM Number',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _results.isEmpty && _query.isNotEmpty
                ? const Center(child: Text('No parts found.'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final part = _results[index];
                      return ListTile(
                        title: Text(part.name),
                        subtitle: Text('OEM: ${part.oemNumber}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(part.name),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('OEM: ${part.oemNumber}'),
                                  if (part.notes != null) ...[
                                    const SizedBox(height: 8),
                                    Text(part.notes!),
                                  ],
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
