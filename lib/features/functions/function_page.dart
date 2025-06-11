import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibes_ui/features/app/app_providers.dart';
import 'package:vibes_ui/features/functions/function.dart';
import 'package:vibes_ui/shared/theme/grid.dart';

final selectedFunctionProvider = StateProvider<FunctionModel?>((ref) => null);

class FunctionPage extends HookConsumerWidget {
  const FunctionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final function = ref.watch(selectedFunctionProvider);
    final theme = ref.watch(darkModeProvider)
        ? themeMap['atom-one-dark']!
        : themeMap['atom-one-light']!;

    if (function == null) {
      return const Center(child: Text('Select a function to view its details'));
    }

    return Padding(
      padding: const EdgeInsets.all(Grid.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            function.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: Grid.sm),
          Text(
            function.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: Grid.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: HighlightView(
              function.signature,
              language: 'typescript',
              theme: theme,
              padding: const EdgeInsets.all(Grid.sm),
            ),
          ),
          const SizedBox(height: Grid.lg),
          Text(function.definition),
        ],
      ),
    );
  }
}
