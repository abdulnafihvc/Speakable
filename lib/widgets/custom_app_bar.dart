import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final IconData? icon;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color? themeColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.icon,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = themeColor ?? Theme.of(context).primaryColor;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [primaryColor.withOpacity(0.05), primaryColor.withOpacity(0.02)],
          ),
        ),
      ),
      leading: showBackButton 
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: primaryColor, size: 18),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && titleWidget == null) ...[
            Icon(icon, color: primaryColor, size: 22),
            const SizedBox(width: 8),
          ],
          titleWidget ?? Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 19,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
