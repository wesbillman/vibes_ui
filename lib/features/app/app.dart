import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibes_ui/features/app/app_drawer.dart';
import 'package:vibes_ui/features/app/app_providers.dart';
import 'package:vibes_ui/shared/theme/theme.dart';
import 'package:vibes_ui/shared/widgets/nav_bar.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        key: scaffoldKey,
        drawer: const AppDrawer(),
        body: Column(
          children: [
            NavBar(
              path: '/Users/wesb/dev/ftl/',
              onPathPressed: () => print('path pressed'),
              onSettingsPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Center(child: Text('Vibes'))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
