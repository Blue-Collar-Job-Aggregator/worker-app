import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';

class _RoleOption {
  const _RoleOption({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
}

const _options = <_RoleOption>[
  _RoleOption(
    role: UserRole.employer,
    title: 'Employer',
    subtitle: 'Post jobs and hire skilled workers',
    icon: Icons.business_center_rounded,
  ),
  _RoleOption(
    role: UserRole.worker,
    title: 'Worker',
    subtitle: 'Find jobs that match your skills',
    icon: Icons.handyman_rounded,
  ),
  _RoleOption(
    role: UserRole.customer,
    title: 'Customer',
    subtitle: 'Book workers for one-time services',
    icon: Icons.person_rounded,
  ),
];

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole? _selected;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final canContinue = _selected != null && !state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () =>
              ref.read(authControllerProvider.notifier).signOut(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text('How will you use Arohi?', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Pick the role that fits you best. You can change this later.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    return _RoleCard(
                      option: option,
                      selected: _selected == option.role,
                      onTap: () => setState(() => _selected = option.role),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () => ref
                          .read(authControllerProvider.notifier)
                          .setRole(_selected!)
                      : null,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected ? AppShadows.card : AppShadows.soft,
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
                child: Icon(option.icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title, style: AppTextStyles.bodyStrong),
                    const SizedBox(height: 2),
                    Text(option.subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
