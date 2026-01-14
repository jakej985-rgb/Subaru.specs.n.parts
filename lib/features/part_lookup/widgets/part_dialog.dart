import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:specsnparts/data/db/app_db.dart';
import 'package:specsnparts/theme/tokens.dart';
import 'package:specsnparts/theme/widgets/neon_chip.dart';

class PartDialog extends StatelessWidget {
  final Part part;

  const PartDialog({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeTokens.surfaceRaised,
      title: Text(
        part.name,
        style: const TextStyle(color: ThemeTokens.textPrimary),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OEM: ${part.oemNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeTokens.textPrimary,
              ),
            ),
            ..._buildAftermarketNumbers(context, part.aftermarketNumbers),
            ..._buildFitsChips(part.fits),
            if (part.notes != null) ...[
              const SizedBox(height: 12),
              Text(
                part.notes!,
                style: const TextStyle(
                  color: ThemeTokens.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: part.oemNumber));
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OEM number copied'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy OEM'),
          style: TextButton.styleFrom(foregroundColor: ThemeTokens.neonBlue),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: ThemeTokens.neonBlue),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAftermarketNumbers(
    BuildContext context,
    String jsonString,
  ) {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      if (data.isEmpty) return [];

      return [
        const SizedBox(height: 12),
        const Text(
          'Aftermarket:',
          style: TextStyle(fontSize: 12, color: ThemeTokens.textMuted),
        ),
        const SizedBox(height: 4),
        ...data.entries.map(
          (e) => InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: '${e.value}'));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied ${e.key} number'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${e.key}: ${e.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: ThemeTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.copy,
                    size: 14,
                    color: ThemeTokens.textMuted.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    } catch (_) {
      return [];
    }
  }

  List<Widget> _buildFitsChips(String jsonString) {
    try {
      final List<dynamic> data = json.decode(jsonString);
      if (data.isEmpty || (data.length == 1 && data[0] == 'All')) {
        return [];
      }

      return [
        const SizedBox(height: 12),
        const Text(
          'Fits:',
          style: TextStyle(fontSize: 12, color: ThemeTokens.textMuted),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: data.map((e) => NeonChip(label: e.toString())).toList(),
        ),
      ];
    } catch (_) {
      return [];
    }
  }
}
