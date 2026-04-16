import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/shadows.dart';
import '../theme/spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.shadow = AppCardShadow.soft,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final AppCardShadow shadow;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final boxShadow = switch (shadow) {
      AppCardShadow.none => <BoxShadow>[],
      AppCardShadow.soft => AppShadows.soft,
      AppCardShadow.card => AppShadows.card,
      AppCardShadow.elevated => AppShadows.elevated,
    };

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : Border.all(color: AppColors.borderLight),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: padding ??
                const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

enum AppCardShadow { none, soft, card, elevated }
