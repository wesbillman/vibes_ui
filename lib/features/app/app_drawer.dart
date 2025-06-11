import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibes_ui/features/app/app_providers.dart';
import 'package:vibes_ui/shared/theme/grid.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(Grid.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Vibes'),
            const Spacer(),
            Row(
              children: [
                Text('Dark Mode'),
                Spacer(),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) async {
                    await ref
                        .read(darkModeProvider.notifier)
                        .setDarkMode(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
