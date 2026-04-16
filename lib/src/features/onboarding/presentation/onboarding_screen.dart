import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../router/app_router.dart';
import '../../auth/application/auth_controller.dart';
import 'widgets/onboarding_illustration.dart';
import 'widgets/page_indicator.dart';

const _kOnboardingSeenKey = 'onboarding_seen';

final onboardingSeenProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(_kOnboardingSeenKey) ?? false;
});

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final IllustrationType illustration;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}

const _pages = [
  _OnboardingPageData(
    title: 'Find Skilled Workers\nInstantly',
    subtitle: 'Hire trusted workers for any job, anytime.',
    illustration: IllustrationType.findWorkers,
  ),
  _OnboardingPageData(
    title: 'Let Contractors\nManage Work',
    subtitle: 'Assign jobs to contractors who handle teams for you.',
    illustration: IllustrationType.manageTeams,
  ),
  _OnboardingPageData(
    title: 'Work & Earn\nEasily',
    subtitle: 'Workers and contractors grow with more opportunities.',
    illustration: IllustrationType.workAndEarn,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _currentPage = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kOnboardingSeenKey, true);
    if (mounted) {
      context.go(AppRoutes.phone);
    }
  }

  void _next() {
    if (_currentPage.round() < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage.round() == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.sm,
                  right: AppSpacing.lg,
                ),
                child: TextButton(
                  onPressed: _complete,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Indicator
            PageIndicator(
              count: _pages.length,
              currentPage: _currentPage,
            ),

            SizedBox(height: 32.h),

            // Action button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: PrimaryButton(
                label: isLastPage ? 'Get Started' : 'Next',
                onPressed: _next,
                icon: isLastPage ? Icons.arrow_forward_rounded : null,
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),

          // Illustration
          OnboardingIllustration(
            type: data.illustration,
            size: 260.w,
          ),

          const Spacer(flex: 1),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.displaySmall,
          ),

          SizedBox(height: 12.h),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
