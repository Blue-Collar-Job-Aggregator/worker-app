import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../jobs/data/job_providers.dart';
import '../../jobs/domain/job.dart';
import '../data/application_providers.dart';
import '../domain/application.dart';
import 'widgets/application_card.dart';

class ApplicationsForJobScreen extends ConsumerWidget {
  const ApplicationsForJobScreen({super.key, required this.jobId});

  final String jobId;

  Job? _lookupJob(WidgetRef ref) {
    final jobs = ref.watch(jobListProvider);
    for (final job in jobs) {
      if (job.id == jobId) return job;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = _lookupJob(ref);
    final applications = ref.watch(applicationsForJobProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: const Text('Applications', style: AppTextStyles.heading2),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                if (job != null) _JobHeader(job: job),
                Expanded(
                  child: applications.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.xl,
                          ),
                          itemCount: applications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final application = applications[index];
                            return ApplicationCard(
                              application: application,
                              onAccept: () => _update(
                                ref,
                                context,
                                application,
                                ApplicationStatus.accepted,
                              ),
                              onReject: () => _update(
                                ref,
                                context,
                                application,
                                ApplicationStatus.rejected,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _update(
    WidgetRef ref,
    BuildContext context,
    Application application,
    ApplicationStatus newStatus,
  ) {
    ref
        .read(applicationListProvider.notifier)
        .updateStatus(application.id, newStatus);
    final label = newStatus == ApplicationStatus.accepted
        ? 'Accepted'
        : 'Rejected';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label application')),
    );
  }
}

class _JobHeader extends StatelessWidget {
  const _JobHeader({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.title, style: AppTextStyles.heading2),
          const SizedBox(height: 2),
          Text(job.location, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(
            job.salary,
            style: AppTextStyles.bodyStrong.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('No applications yet', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Workers applying to this job will appear here.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
