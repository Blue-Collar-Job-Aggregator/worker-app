import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/radius.dart';
import '../../../../core/theme/shadows.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/worker_listing.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key, required this.worker, this.onTap});

  final WorkerListing worker;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: Text(
                  worker.initials,
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(worker.name, style: AppTextStyles.bodyStrong),
                    const SizedBox(height: 2),
                    Text(worker.trade, style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          worker.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${worker.distanceKm} km away',
                          style: AppTextStyles.small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${worker.hourlyRate}',
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text('/hr', style: AppTextStyles.small),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
