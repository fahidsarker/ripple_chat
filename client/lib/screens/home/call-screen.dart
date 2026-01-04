import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/widgets/toolbar.dart';

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(child: const Center(child: Text('Calls Area')));
  }
}
