import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

/// Semantic text widget that maps to the design system typography.
///
/// Usage:
/// ```dart
/// AppText.heading1('Welcome')
/// AppText.body('Description text', color: AppColors.textSecondary)
/// AppText.caption('Subtitle')
/// ```
class AppText extends StatelessWidget {
  const AppText._(this.text, this.baseStyle, {this.color, this.maxLines, this.align, this.overflow});

  final String text;
  final TextStyle Function() baseStyle;
  final Color? color;
  final int? maxLines;
  final TextAlign? align;
  final TextOverflow? overflow;

  factory AppText.displayLarge(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.displayLarge, color: color, maxLines: maxLines, align: align);

  factory AppText.displaySmall(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.displaySmall, color: color, maxLines: maxLines, align: align);

  factory AppText.heading1(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.heading1, color: color, maxLines: maxLines, align: align);

  factory AppText.heading2(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.heading2, color: color, maxLines: maxLines, align: align);

  factory AppText.heading3(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.heading3, color: color, maxLines: maxLines, align: align);

  factory AppText.body(String text, {Color? color, int? maxLines, TextAlign? align, TextOverflow? overflow}) =>
      AppText._(text, () => AppTextStyles.body, color: color, maxLines: maxLines, align: align, overflow: overflow);

  factory AppText.bodyStrong(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.bodyStrong, color: color, maxLines: maxLines, align: align);

  factory AppText.bodySmall(String text, {Color? color, int? maxLines, TextAlign? align, TextOverflow? overflow}) =>
      AppText._(text, () => AppTextStyles.bodySmall, color: color, maxLines: maxLines, align: align, overflow: overflow);

  factory AppText.caption(String text, {Color? color, int? maxLines, TextAlign? align, TextOverflow? overflow}) =>
      AppText._(text, () => AppTextStyles.caption, color: color, maxLines: maxLines, align: align, overflow: overflow);

  factory AppText.small(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.small, color: color, maxLines: maxLines, align: align);

  factory AppText.label(String text, {Color? color, int? maxLines, TextAlign? align}) =>
      AppText._(text, () => AppTextStyles.label, color: color, maxLines: maxLines, align: align);

  @override
  Widget build(BuildContext context) {
    final style = baseStyle();
    return Text(
      text,
      style: color != null ? style.copyWith(color: color) : style,
      maxLines: maxLines,
      textAlign: align,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
