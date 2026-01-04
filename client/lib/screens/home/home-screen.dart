import 'package:flutter/material.dart';
import 'package:ripple_client/widgets/toolbar.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Assuming Toolbar is a custom widget defined elsewhere
            Toolbar(),
            const SizedBox(width: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
