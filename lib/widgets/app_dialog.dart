import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Custom styled dialog matching app theme
class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.secondaryDark,
                    AppColors.primaryDark,
                  ]
                : [
                    Colors.white,
                    AppColors.primaryLight,
                  ],
          ),
          border: Border.all(
            color: AppColors.highlightColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.highlightColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.highlightColor,
                    AppColors.neonPurple,
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: content,
            ),
            // Actions
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!
                      .map((action) => Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: action,
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Show a simple confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        icon: icon ?? Icons.help_outline,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
          ),
        ),
        actions: [
          AppTextButton(
            onPressed: () => Navigator.pop(context, false),
            text: cancelText ?? l10n.cancel,
          ),
          AppButton(
            onPressed: () => Navigator.pop(context, true),
            text: confirmText ?? l10n.yes,
          ),
        ],
      ),
    );
  }

  /// Show an info dialog
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        icon: icon ?? Icons.info_outline,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
          ),
        ),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            text: buttonText ?? l10n.ok,
          ),
        ],
      ),
    );
  }

  /// Show a success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.goldColor,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
          ),
        ),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            text: buttonText ?? l10n.ok,
          ),
        ],
      ),
    );
  }

  /// Show an error dialog
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        icon: Icons.error_outline,
        iconColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
          ),
        ),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            text: buttonText ?? l10n.ok,
          ),
        ],
      ),
    );
  }
}

/// Custom styled button for dialogs
class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.highlightColor, AppColors.neonPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.highlightColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom styled text button for dialogs
class AppTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

/// Custom styled snackbar
class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    bool isSuccess = false,
    bool isError = false,
  }) {
    Color bgColor = AppColors.highlightColor;
    if (isSuccess) bgColor = const Color(0xFF27AE60);
    if (isError) bgColor = const Color(0xFFE74C3C);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgColor, bgColor.withOpacity(0.8)],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
              ] else if (isSuccess) ...[
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 12),
              ] else if (isError) ...[
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
