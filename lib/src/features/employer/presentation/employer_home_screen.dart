import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/role_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../../jobs/data/job_providers.dart';
import '../../jobs/presentation/widgets/job_card.dart';

class EmployerHomeScreen extends ConsumerWidget {
  const EmployerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authControllerProvider).profile;
    final company =
        profile is EmployerProfile ? profile.companyName : 'your company';
    final jobs = ref.watch(jobsByEmployerProvider(company));

    return RoleScaffold(
      roleLabel: 'EMPLOYER',
      greeting: company,
      subtitle: 'Post jobs and manage hiring',
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: _PostJobCta(onPressed: () => context.push('/post-job')),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SectionHeader(
              title: 'Posted jobs',
              actionLabel: jobs.isEmpty ? null : '${jobs.length} total',
            ),
          ),
        ),
        if (jobs.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyPostedState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            sliver: SliverList.separated(
              itemCount: jobs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) {
                final job = jobs[i];
                return JobCard(
                  job: job,
                  onTap: () =>
                      context.push('/applications/job/${job.id}'),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _PostJobCta extends StatelessWidget {
  const _PostJobCta({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Post a new job', style: AppTextStyles.bodyStrong),
                    SizedBox(height: 2),
                    Text(
                      'Reach 10k+ verified workers in NCR',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPostedState extends StatelessWidget {
  const _EmptyPostedState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.work_outline_rounded,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "You haven't posted any jobs yet",
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap "Post a new job" above to publish your first listing.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
