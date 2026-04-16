import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/applications/presentation/applications_for_job_screen.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/phone_input_screen.dart';
import '../features/customer/presentation/customer_home_screen.dart';
import '../features/employer/presentation/employer_home_screen.dart';
import '../features/employer/presentation/post_job_screen.dart';
import '../features/jobs/domain/job.dart';
import '../features/jobs/presentation/job_detail_screen.dart';
import '../features/jobs/presentation/job_list_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/region/presentation/region_screen.dart';
import '../features/role/presentation/role_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/worker/presentation/worker_home_screen.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const phone = '/phone';
  static const otp = '/otp';
  static const region = '/region';
  static const role = '/role';
  static const profile = '/profile';
  static const employerHome = '/home/employer';
  static const workerHome = '/home/worker';
  static const customerHome = '/home/customer';
  static const jobs = '/jobs';
  static const postJob = '/post-job';
  static const applications = '/applications';

  static String homeForRole(UserRole role) {
    switch (role) {
      case UserRole.employer:
        return employerHome;
      case UserRole.worker:
        return workerHome;
      case UserRole.customer:
        return customerHome;
    }
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefresh(ref);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;

      // Allow splash and onboarding screens to display without redirect
      if (loc == AppRoutes.splash || loc == AppRoutes.onboarding) return null;

      switch (auth.status) {
        case AuthStatus.signedOut:
          return loc == AppRoutes.phone ? null : AppRoutes.phone;

        case AuthStatus.awaitingOtp:
          return loc == AppRoutes.otp ? null : AppRoutes.otp;

        case AuthStatus.signedIn:
          switch (auth.onboardingStep) {
            case OnboardingStep.chooseRegion:
              return loc == AppRoutes.region ? null : AppRoutes.region;
            case OnboardingStep.chooseRole:
              return loc == AppRoutes.role ? null : AppRoutes.role;
            case OnboardingStep.completeProfile:
              return loc == AppRoutes.profile ? null : AppRoutes.profile;
            case OnboardingStep.done:
              if (loc.startsWith(AppRoutes.jobs) ||
                  loc.startsWith(AppRoutes.postJob) ||
                  loc.startsWith(AppRoutes.applications)) {
                return null;
              }
              final target = AppRoutes.homeForRole(auth.role!);
              return loc == target ? null : target;
          }
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.phone,
        builder: (_, __) => const PhoneInputScreen(),
      ),
      GoRoute(path: AppRoutes.otp, builder: (_, __) => const OtpScreen()),
      GoRoute(
        path: AppRoutes.region,
        builder: (_, __) => const RegionScreen(),
      ),
      GoRoute(
        path: AppRoutes.role,
        builder: (_, __) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.employerHome,
        builder: (_, __) => const EmployerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.workerHome,
        builder: (_, __) => const WorkerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.customerHome,
        builder: (_, __) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobs,
        builder: (_, __) => const JobListScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (context, state) =>
                JobDetailScreen(job: state.extra as Job?),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.postJob,
        builder: (_, __) => const PostJobScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.applications}/job/:jobId',
        builder: (context, state) => ApplicationsForJobScreen(
          jobId: state.pathParameters['jobId']!,
        ),
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}
