import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specsnparts/data/db/app_db.dart';


class SpecListPage extends ConsumerStatefulWidget {
  const SpecListPage({super.key});

  @override
  ConsumerState<SpecListPage> createState() => _SpecListPageState();
}

class _SpecListPageState extends ConsumerState<SpecListPage> {

  List<Spec> _results = [];

  void _search(String query) async {
    // query param is used directly below
    if (query.isEmpty) {
       _loadInitial();
      return;
    }
    final db = ref.read(appDbProvider);
    final results = await db.specsDao.searchSpecs(query);
    setState(() => _results = results);
  }

  void _loadInitial() async {
     final db = ref.read(appDbProvider);
     final results = await db.specsDao.getAllSpecs();
     setState(() => _results = results);
  }

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Specs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Specs',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final spec = _results[index];
                return ListTile(
                  title: Text(spec.title),
                  subtitle: Text(spec.category),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                     // Show detail dialog or page
                     showDialog(context: context, builder: (context) => AlertDialog(
                       title: Text(spec.title),
                       content: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Category: ${spec.category}', style: Theme.of(context).textTheme.bodySmall),
                           const SizedBox(height: 8),
                           Text(spec.body),
                           const SizedBox(height: 8),
                           Text('Tags: ${spec.tags}', style: Theme.of(context).textTheme.bodySmall),
                         ],
                       ),
                       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                     ));
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
