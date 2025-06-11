import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vibes_ui/features/app/app_drawer.dart';
import 'package:vibes_ui/features/app/app_providers.dart';
import 'package:vibes_ui/shared/theme/theme.dart';
import 'package:vibes_ui/shared/widgets/nav_bar.dart';
import 'package:vibes_ui/features/projects/projects_sidebar.dart';
import 'package:vibes_ui/features/functions/function_page.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final projectPath = ref.watch(projectPathProvider);

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
              path: projectPath,
              onPathPressed: () async {
                String? selectedDirectory = await FilePicker.platform
                    .getDirectoryPath();
                if (selectedDirectory != null) {
                  await ref
                      .read(projectPathProvider.notifier)
                      .setPath(selectedDirectory);
                }
              },
              onSettingsPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(child: _ResizableSidebarLayout()),
          ],
        ),
      ),
    );
  }
}

class _ResizableSidebarLayout extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final sidebarWidth = useState<double>(220);
    const minWidth = 150.0;
    const maxWidth = 400.0;
    final dragStart = useRef<double?>(null);
    final startWidth = useRef<double?>(null);

    return Row(
      children: [
        SizedBox(width: sidebarWidth.value, child: const ProjectsSidebar()),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (details) {
            dragStart.value = details.globalPosition.dx;
            startWidth.value = sidebarWidth.value;
          },
          onHorizontalDragUpdate: (details) {
            if (dragStart.value != null && startWidth.value != null) {
              final delta = details.globalPosition.dx - dragStart.value!;
              final newWidth = (startWidth.value! + delta).clamp(
                minWidth,
                maxWidth,
              );
              sidebarWidth.value = newWidth;
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: SizedBox(
              width: 4,
              height: double.infinity,
              child: Center(
                child: Container(
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: FunctionPage()),
      ],
    );
  }
}
