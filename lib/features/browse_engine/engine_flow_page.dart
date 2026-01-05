import 'package:flutter/material.dart';

class EngineFlowPage extends StatelessWidget {
  const EngineFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded simple list for MVP
    final engines = ['EJ257', 'EJ205', 'FA20', 'FA24', 'FB25'];

    return Scaffold(
      appBar: AppBar(title: const Text('Browse by Engine')),
      body: ListView.builder(
        itemCount: engines.length,
        itemBuilder: (context, index) {
          final engine = engines[index];
          return ListTile(
            title: Text(engine),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(engine),
                  content: const Text(
                    'Engine details and related parts coming soon.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
