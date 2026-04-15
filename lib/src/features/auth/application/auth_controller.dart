import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Override in main() after SharedPreferences.getInstance()',
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(sharedPreferencesProvider));
});

enum AuthStatus { signedOut, awaitingOtp, signedIn }

enum OnboardingStep { chooseRegion, chooseRole, completeProfile, done }

class AuthState {
  const AuthState({
    required this.status,
    this.phone,
    this.verificationId,
    this.region,
    this.role,
    this.profile,
    this.errorMessage,
    this.isLoading = false,
  });

  final AuthStatus status;
  final String? phone;
  final String? verificationId;
  final String? region;
  final UserRole? role;
  final UserProfile? profile;
  final String? errorMessage;
  final bool isLoading;

  OnboardingStep get onboardingStep {
    if (region == null) return OnboardingStep.chooseRegion;
    if (role == null) return OnboardingStep.chooseRole;
    if (profile == null) return OnboardingStep.completeProfile;
    return OnboardingStep.done;
  }

  AuthState copyWith({
    AuthStatus? status,
    String? phone,
    String? verificationId,
    String? region,
    UserRole? role,
    UserProfile? profile,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      region: region ?? this.region,
      role: role ?? this.role,
      profile: clearProfile ? null : profile ?? this.profile,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository)
      : super(
          AuthState(
            status: _repository.isSignedIn
                ? AuthStatus.signedIn
                : AuthStatus.signedOut,
            phone: _repository.currentPhone,
            region: _repository.currentRegion,
            role: _repository.currentRole,
            profile: _repository.currentProfile,
          ),
        );

  final AuthRepository _repository;

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final verificationId = await _repository.sendOtp(phone);
      state = AuthState(
        status: AuthStatus.awaitingOtp,
        phone: phone,
        verificationId: verificationId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send OTP',
      );
    }
  }

  Future<void> verifyOtp(String code) async {
    final verificationId = state.verificationId;
    if (verificationId == null) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final ok = await _repository.verifyOtp(
        verificationId: verificationId,
        code: code,
      );
      if (ok) {
        state = AuthState(
          status: AuthStatus.signedIn,
          phone: state.phone,
          region: _repository.currentRegion,
          role: _repository.currentRole,
          profile: _repository.currentProfile,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid code. Try 123456.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Verification failed',
      );
    }
  }

  Future<void> setRegion(String region) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _repository.saveRegion(region);
    state = state.copyWith(region: region, isLoading: false);
  }

  Future<void> setRole(UserRole role) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _repository.saveRole(role);
    state = state.copyWith(role: role, isLoading: false, clearProfile: true);
  }

  Future<void> saveProfile(UserProfile profile) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _repository.saveProfile(profile);
    state = state.copyWith(profile: profile, isLoading: false);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState(status: AuthStatus.signedOut);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
