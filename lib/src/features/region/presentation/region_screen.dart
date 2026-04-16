import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/shadows.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/application/auth_controller.dart';

class _Region {
  const _Region({
    required this.code,
    required this.name,
    required this.tagline,
    required this.enabled,
  });

  final String code;
  final String name;
  final String tagline;
  final bool enabled;
}

const _regions = <_Region>[
  _Region(
    code: 'NCR',
    name: 'Delhi NCR',
    tagline: 'Delhi, Noida, Gurugram, Faridabad, Ghaziabad',
    enabled: true,
  ),
  _Region(
    code: 'MUM',
    name: 'Mumbai',
    tagline: 'Coming soon',
    enabled: false,
  ),
  _Region(
    code: 'BLR',
    name: 'Bengaluru',
    tagline: 'Coming soon',
    enabled: false,
  ),
];

class RegionScreen extends ConsumerStatefulWidget {
  const RegionScreen({super.key});

  @override
  ConsumerState<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends ConsumerState<RegionScreen> {
  String? _selected = 'NCR';

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
              Text('Choose your city', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We only operate in select regions right now.',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: _regions.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    return _RegionTile(
                      region: region,
                      selected: _selected == region.code,
                      onTap: region.enabled
                          ? () => setState(() => _selected = region.code)
                          : null,
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
                          .setRegion(_selected!)
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

class _RegionTile extends StatelessWidget {
  const _RegionTile({
    required this.region,
    required this.selected,
    required this.onTap,
  });

  final _Region region;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
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
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected ? AppShadows.card : AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: disabled
                      ? AppColors.border
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.location_city_rounded,
                  color: disabled ? AppColors.textMuted : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      region.name,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: disabled
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(region.tagline, style: AppTextStyles.small),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                )
              else if (disabled)
                const Icon(
                  Icons.lock_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
