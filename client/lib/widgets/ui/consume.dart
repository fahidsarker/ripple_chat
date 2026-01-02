import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class Consume<StateT> extends ConsumerWidget {
  final ProviderListenable<StateT> provider;
  final Widget Function(BuildContext, StateT) builder;
  const Consume({super.key, required this.provider, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return builder(context, state);
  }
}

class AsyncConsume<StateT> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<StateT>> provider;
  final Widget Function(BuildContext, StateT) builder;
  const AsyncConsume({
    super.key,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return state.when(
      data: (data) => builder(context, data),
      loading: () => const CircularProgressIndicator.adaptive(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
