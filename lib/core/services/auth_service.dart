import 'package:yanyana_p/core/constants/app_constants.dart';
import 'package:yanyana_p/shared/data/mock_data.dart';
import 'package:yanyana_p/shared/models/app_user.dart';

/// Mock authentication facade for the YanYana prototype.
///
/// Later this can be mapped to Firebase Authentication (email/password,
/// phone, OAuth, etc.) without changing higher-level feature code.
class AuthService {
  const AuthService();

  static final Map<String, AppUser> _usersByEmail = {
    MockData.currentUser.email.toLowerCase(): MockData.currentUser,
  };

  static AppUser? _sessionUser = MockData.currentUser;

  /// Active session user, or `null` after [signOut].
  AppUser? getCurrentUser() => _sessionUser;

  /// Demo fallback when no session (used by other mock services).
  static AppUser get resolvedUser => _sessionUser ?? MockData.currentUser;

  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final key = email.trim().toLowerCase();
    final user = _usersByEmail[key];
    if (user == null) {
      throw StateError('Mock: bilinmeyen e-posta ($email). Önce kayıt olun.');
    }
    if (password.isEmpty) {
      throw StateError('Mock: şifre boş olamaz.');
    }
    _sessionUser = user;
    return user;
  }

  Future<AppUser> registerWithEmailAndPassword(
    String fullName,
    String email,
    String password,
    String role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (_usersByEmail.containsKey(key)) {
      throw StateError('Mock: bu e-posta zaten kayıtlı.');
    }
    if (password.length < 8) {
      throw StateError('Mock: şifre en az 8 karakter olmalı.');
    }
    final technical = _coerceRole(role);
    final user = AppUser(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName.trim(),
      email: key,
      role: technical,
      disabilityType: '—',
      communicationPreference: 'Metin',
      interests: const [],
      points: 0,
      badges: const [],
    );
    _usersByEmail[key] = user;
    _sessionUser = user;
    return user;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _sessionUser = null;
  }

  static String _coerceRole(String role) {
    const known = {
      AppRole.disabledUser,
      AppRole.volunteer,
      AppRole.admin,
      AppRole.moderator,
    };
    if (known.contains(role)) return role;
    return AppRole.disabledUser;
  }
}
