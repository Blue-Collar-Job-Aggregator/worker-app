import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/widgets/role_scaffold.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../../directory/data/directory_providers.dart';
import '../../directory/presentation/widgets/worker_card.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authControllerProvider).profile;
    final firstName = profile is CustomerProfile
        ? profile.fullName.split(' ').first
        : 'there';
    final workers = ref.watch(workerDirectoryProvider);

    return RoleScaffold(
      roleLabel: 'CUSTOMER',
      greeting: 'Hello, $firstName',
      subtitle: 'Find trusted workers near you',
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SearchField(
              hintText: 'Search electricians, plumbers, cleaners…',
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SectionHeader(
              title: 'Top rated near you',
              actionLabel: 'See all',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          sliver: SliverList.separated(
            itemCount: workers.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, i) => WorkerCard(worker: workers[i]),
          ),
        ),
      ],
    );
  }
}
