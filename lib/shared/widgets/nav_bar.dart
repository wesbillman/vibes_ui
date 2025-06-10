import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String path;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onPathPressed;

  const NavBar({
    super.key,
    required this.path,
    this.onSettingsPressed,
    this.onPathPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 24),
            onPressed: onSettingsPressed,
            tooltip: 'Settings',
          ),
          const Spacer(),
          TextButton(onPressed: onPathPressed, child: Text(path)),
        ],
      ),
    );
  }
}
