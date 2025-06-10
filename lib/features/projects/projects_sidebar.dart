import 'package:flutter/material.dart';
import 'package:vibes_ui/shared/theme/grid.dart';

class ProjectsSidebar extends StatelessWidget {
  const ProjectsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TreeSliverController();
    // Example static tree data
    final tree = [
      TreeSliverNode<_TreeNode>(
        _TreeNode('echo'),
        children: [TreeSliverNode<_TreeNode>(_TreeNode('echo'))],
      ),
      TreeSliverNode<_TreeNode>(
        _TreeNode('invoice'),
        children: [TreeSliverNode<_TreeNode>(_TreeNode('invoice'))],
      ),
      TreeSliverNode<_TreeNode>(
        _TreeNode('time'),
        children: [TreeSliverNode<_TreeNode>(_TreeNode('time'))],
      ),
    ];

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: Grid.xs),
          sliver: TreeSliver<_TreeNode>(
            tree: tree,
            controller: controller,
            treeNodeBuilder: (context, node, animationStyle) {
              final isFolder = node.children.isNotEmpty;
              return InkWell(
                onTap: isFolder
                    ? () => controller.toggleNode(node)
                    : () => print(node),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Grid.sm),
                  child: Row(
                    children: [
                      if (isFolder)
                        Icon(
                          node.isExpanded ? Icons.folder_open : Icons.folder,
                          size: 18,
                        )
                      else
                        const Icon(Icons.bolt, size: 18),
                      const SizedBox(width: 8),
                      Text((node.content as _TreeNode).name),
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
}

class _TreeNode {
  final String name;
  const _TreeNode(this.name);
}
