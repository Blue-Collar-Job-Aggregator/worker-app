import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/search_field.dart';
import '../../auth/application/auth_controller.dart';
import '../../jobs/data/job_providers.dart';
import '../../jobs/domain/job.dart';
import '../../jobs/presentation/widgets/job_card.dart';

class WorkerHomeScreen extends ConsumerWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(filteredJobListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: AppSpacing.lg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Find Work', style: AppTextStyles.heading1),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 2),
                Text('Delhi NCR', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Browse all',
            icon: const Icon(
              Icons.list_alt_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.push('/jobs'),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: SearchField(
                    hintText: 'Search jobs by title…',
                    onChanged: (value) => ref
                        .read(searchQueryProvider.notifier)
                        .state = value,
                  ),
                ),
                Expanded(
                  child: _JobListView(jobs: jobs),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JobListView extends StatelessWidget {
  const _JobListView({required this.jobs});

  final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const _EmptyState();
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(
          job: job,
          onTap: () => context.push('/jobs/detail', extra: job),
        );
      },
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
              Icons.search_off_rounded,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No matching jobs', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Try a different keyword or clear the search.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
