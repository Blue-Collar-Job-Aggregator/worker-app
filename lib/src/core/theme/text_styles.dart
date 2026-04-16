import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // --- Display (Poppins — used for hero/splash text) ---

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  // --- Headings (Poppins) ---

  static TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get heading3 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      );

  // --- Body (Inter) ---

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyStrong => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.45,
      );

  // --- Caption / Small (Inter) ---

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get small => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 1.3,
      );

  // --- Button (Inter) ---

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get buttonSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  // --- Label (Inter) ---

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
        height: 1.3,
      );
}
