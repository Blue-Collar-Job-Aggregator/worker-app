import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { employer, worker, customer }

sealed class UserProfile {
  const UserProfile();

  UserRole get role;
  String get displayName;
  String get secondaryLine;
}

class EmployerProfile extends UserProfile {
  const EmployerProfile({
    required this.companyName,
    required this.companyAddress,
  });

  final String companyName;
  final String companyAddress;

  @override
  UserRole get role => UserRole.employer;

  @override
  String get displayName => companyName;

  @override
  String get secondaryLine => companyAddress;
}

class WorkerProfile extends UserProfile {
  const WorkerProfile({required this.fullName, required this.primarySkill});

  final String fullName;
  final String primarySkill;

  @override
  UserRole get role => UserRole.worker;

  @override
  String get displayName => fullName;

  @override
  String get secondaryLine => primarySkill;
}

class CustomerProfile extends UserProfile {
  const CustomerProfile({required this.fullName, required this.address});

  final String fullName;
  final String address;

  @override
  UserRole get role => UserRole.customer;

  @override
  String get displayName => fullName;

  @override
  String get secondaryLine => address;
}

class AuthRepository {
  AuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kPhoneKey = 'auth.phone';
  static const _kVerificationIdKey = 'auth.verificationId';
  static const _kRegionKey = 'auth.region';
  static const _kRoleKey = 'auth.role';
  static const _kProfileField1Key = 'auth.profile.field1';
  static const _kProfileField2Key = 'auth.profile.field2';

  String? _pendingVerificationId;
  String? _pendingPhone;

  String? get currentPhone => _prefs.getString(_kPhoneKey);
  bool get isSignedIn => currentPhone != null;

  String? get currentRegion => _prefs.getString(_kRegionKey);

  UserRole? get currentRole {
    final raw = _prefs.getString(_kRoleKey);
    if (raw == null) return null;
    return UserRole.values.firstWhere(
      (r) => r.name == raw,
      orElse: () => UserRole.customer,
    );
  }

  UserProfile? get currentProfile {
    final role = currentRole;
    final f1 = _prefs.getString(_kProfileField1Key);
    final f2 = _prefs.getString(_kProfileField2Key);
    if (role == null || f1 == null || f2 == null) return null;
    return switch (role) {
      UserRole.employer =>
        EmployerProfile(companyName: f1, companyAddress: f2),
      UserRole.worker => WorkerProfile(fullName: f1, primarySkill: f2),
      UserRole.customer => CustomerProfile(fullName: f1, address: f2),
    };
  }

  Future<String> sendOtp(String phone) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final verificationId = DateTime.now().millisecondsSinceEpoch.toString();
    _pendingVerificationId = verificationId;
    _pendingPhone = phone;
    await _prefs.setString(_kVerificationIdKey, verificationId);
    return verificationId;
  }

  Future<bool> verifyOtp({
    required String verificationId,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (verificationId != _pendingVerificationId) return false;
    if (code != '123456') return false;
    final phone = _pendingPhone;
    if (phone == null) return false;
    await _prefs.setString(_kPhoneKey, phone);
    await _prefs.remove(_kVerificationIdKey);
    _pendingPhone = null;
    _pendingVerificationId = null;
    return true;
  }

  Future<void> saveRegion(String region) async {
    await _prefs.setString(_kRegionKey, region);
  }

  Future<void> saveRole(UserRole role) async {
    await _prefs.setString(_kRoleKey, role.name);
    await _prefs.remove(_kProfileField1Key);
    await _prefs.remove(_kProfileField2Key);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final (f1, f2) = switch (profile) {
      EmployerProfile(:final companyName, :final companyAddress) => (
          companyName,
          companyAddress,
        ),
      WorkerProfile(:final fullName, :final primarySkill) => (
          fullName,
          primarySkill,
        ),
      CustomerProfile(:final fullName, :final address) => (fullName, address),
    };
    await _prefs.setString(_kProfileField1Key, f1);
    await _prefs.setString(_kProfileField2Key, f2);
  }

  Future<void> signOut() async {
    await _prefs.remove(_kPhoneKey);
    await _prefs.remove(_kVerificationIdKey);
    await _prefs.remove(_kRegionKey);
    await _prefs.remove(_kRoleKey);
    await _prefs.remove(_kProfileField1Key);
    await _prefs.remove(_kProfileField2Key);
  }
}
