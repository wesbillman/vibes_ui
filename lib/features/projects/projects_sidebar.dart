import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibes_ui/features/app/app_providers.dart';
import 'package:vibes_ui/features/functions/function.dart';
import 'package:vibes_ui/features/functions/function_page.dart';
import 'package:vibes_ui/shared/theme/grid.dart';

class ProjectsSidebar extends HookConsumerWidget {
  const ProjectsSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TreeSliverController();
    final projectPath = ref.watch(projectPathProvider);
    final treeNodes = useState<List<TreeSliverNode<_TreeNode>>>([]);
    final selectedNode = useState<_TreeNode?>(null);

    useEffect(() {
      if (projectPath.isEmpty) return null;

      void updateTree() {
        final nodes = <TreeSliverNode<_TreeNode>>[];
        final dir = Directory(projectPath);

        if (!dir.existsSync()) return;

        for (final entity in dir.listSync(recursive: true)) {
          if (entity is File && entity.path.endsWith('spec.json')) {
            try {
              final content = entity.readAsStringSync();
              final spec = json.decode(content) as Map<String, dynamic>;

              // Create root node for the spec
              final rootNode = TreeSliverNode<_TreeNode>(
                _TreeNode(spec['name'] as String, type: NodeType.module),
                children: [
                  // Config section
                  if (spec['config'] != null)
                    TreeSliverNode<_TreeNode>(
                      _TreeNode('config', type: NodeType.folder),
                      children: [
                        for (final entry
                            in (spec['config'] as Map<String, dynamic>).entries)
                          TreeSliverNode<_TreeNode>(
                            _TreeNode(
                              '${entry.key}: ${entry.value}',
                              type: NodeType.config,
                            ),
                          ),
                      ],
                    ),

                  // Functions section
                  if (spec['functions'] != null)
                    TreeSliverNode<_TreeNode>(
                      _TreeNode('functions', type: NodeType.folder),
                      children: [
                        for (final func in spec['functions'] as List)
                          TreeSliverNode<_TreeNode>(
                            _TreeNode(
                              func['name'] as String,
                              type: NodeType.function,
                              functionModel: FunctionModel.fromJson(func),
                            ),
                          ),
                      ],
                    ),

                  // Test suites section
                  if (spec['test_suites'] != null)
                    TreeSliverNode<_TreeNode>(
                      _TreeNode('test_suites', type: NodeType.folder),
                      children: [
                        for (final suite in spec['test_suites'] as List)
                          TreeSliverNode<_TreeNode>(
                            _TreeNode(
                              suite['name'] as String,
                              type: NodeType.folder,
                            ),
                            children: [
                              TreeSliverNode<_TreeNode>(
                                _TreeNode('tests', type: NodeType.folder),
                                children: [
                                  for (final test in suite['tests'] as List)
                                    TreeSliverNode<_TreeNode>(
                                      _TreeNode(
                                        test['name'] as String,
                                        type: NodeType.test,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              );

              nodes.add(rootNode);
            } catch (e) {
              print('Error parsing spec.json: $e');
            }
          }
        }

        treeNodes.value = nodes;
      }

      // Initial update
      updateTree();

      // Watch for changes
      final watcher = Directory(projectPath).watch(recursive: true);
      final subscription = watcher.listen((event) {
        if (event.path.endsWith('spec.json')) {
          updateTree();
        }
      });

      return () {
        subscription.cancel();
      };
    }, [projectPath]);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: Grid.xs),
          sliver: TreeSliver<_TreeNode>(
            tree: treeNodes.value,
            controller: controller,
            treeNodeBuilder: (context, node, animationStyle) {
              final isFolder = node.children.isNotEmpty;
              final content = node.content as _TreeNode;
              final isSelected = selectedNode.value == content;

              return InkWell(
                onTap: () {
                  if (isFolder) {
                    controller.toggleNode(node);
                  } else {
                    selectedNode.value = content;
                    if (content.type == NodeType.function &&
                        content.functionModel != null) {
                      ref.read(selectedFunctionProvider.notifier).state =
                          content.functionModel;
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.3)
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Grid.sm),
                  child: Row(
                    children: [
                      Icon(
                        _getIconForNodeType(
                          content.type,
                          isFolder ? node.isExpanded : null,
                        ),
                        size: 18,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          content.name,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForNodeType(NodeType type, bool? isExpanded) {
    switch (type) {
      case NodeType.module:
        return Icons.extension;
      case NodeType.folder:
        return isExpanded == true ? Icons.folder_open : Icons.folder;
      case NodeType.function:
        return Icons.functions;
      case NodeType.test:
        return Icons.check_circle;
      case NodeType.config:
        return Icons.settings;
    }
  }
}

enum NodeType { module, folder, function, test, config }

class _TreeNode {
  final String name;
  final NodeType type;
  final FunctionModel? functionModel;
  const _TreeNode(this.name, {this.type = NodeType.folder, this.functionModel});
}
