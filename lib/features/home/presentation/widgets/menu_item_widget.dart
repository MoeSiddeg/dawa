import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppTheme.primaryColor),
        title: Text(title, style: AppTheme.bodyLarge.copyWith(color: color)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: color ?? AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
