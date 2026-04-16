import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../applications/data/application_providers.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/job.dart';

class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({super.key, required this.job});

  final Job? job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text('Job details', style: AppTextStyles.heading2),
      ),
      body: job == null ? const _NotFound() : _JobDetailBody(job: job!),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          "We couldn't load that job. Please go back and try again.",
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _JobDetailBody extends ConsumerWidget {
  const _JobDetailBody({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final applications = ref.watch(applicationListProvider);

    final isWorker = auth.role == UserRole.worker;
    final workerId = auth.phone;
    final hasApplied = workerId != null &&
        applications.any((a) => a.jobId == job.id && a.workerId == workerId);
    final isOpen = job.status == JobStatus.open;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: AppTextStyles.heading1),
                      const SizedBox(height: AppSpacing.sm),
                      Text(job.employerId, style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.lg),
                      _MetaRow(
                        icon: Icons.location_on_rounded,
                        label: 'Location',
                        value: job.location,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _MetaRow(
                        icon: Icons.currency_rupee_rounded,
                        label: 'Salary',
                        value: job.salary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'About the job',
                        style: AppTextStyles.bodyStrong,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(job.description, style: AppTextStyles.body),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: AppShadows.soft,
                ),
                child: _ApplyBar(
                  isWorker: isWorker,
                  isOpen: isOpen,
                  hasApplied: hasApplied,
                  onApply: () => _apply(ref, context, workerId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _apply(WidgetRef ref, BuildContext context, String? workerId) {
    if (workerId == null) return;
    final created = ref
        .read(applicationListProvider.notifier)
        .applyToJob(job.id, workerId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          created
              ? 'Application sent to ${job.employerId}'
              : 'You already applied to this job',
        ),
      ),
    );
  }
}

class _ApplyBar extends StatelessWidget {
  const _ApplyBar({
    required this.isWorker,
    required this.isOpen,
    required this.hasApplied,
    required this.onApply,
  });

  final bool isWorker;
  final bool isOpen;
  final bool hasApplied;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    if (!isWorker) {
      return const _InfoBanner(
        icon: Icons.info_outline_rounded,
        text: 'Only workers can apply to jobs',
      );
    }
    if (!isOpen) {
      return const _InfoBanner(
        icon: Icons.lock_outline_rounded,
        text: 'This job is no longer accepting applications',
      );
    }
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasApplied ? null : onApply,
        child: Text(hasApplied ? 'Applied' : 'Apply Now'),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.small),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyStrong),
            ],
          ),
        ),
      ],
    );
  }
}
