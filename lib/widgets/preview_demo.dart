import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

// Example 1: Simple Text Widget
@Preview(name: 'Hello Preview')
Widget helloPreview() {
  return const Card(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('Hello from the Widget Previewer!'),
    ),
  );
}

// Example 2: Interactive Button
@Preview(name: 'Button Preview')
Widget buttonPreview() {
  return ElevatedButton(
    onPressed: () {
      debugPrint('Preview button clicked');
    },
    child: const Text('Click Me'),
  );
}
