import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../config/supabase/supabase_service.dart';
import '../models/user_model.dart';

class AuthenticationService {
  void _ensureInitialized() {
    if (!SupabaseService.isInitialized) {
      throw Exception(
        'Supabase is not initialized. Call SupabaseService.initialize() first.',
      );
    }
  }

  // Get current user
  User? get currentUser =>
      SupabaseService.isInitialized ? SupabaseManager.auth.currentUser : null;

  // Get current session
  Session? get currentSession =>
      SupabaseService.isInitialized
          ? SupabaseManager.auth.currentSession
          : null;

  // Stream auth state changes
  Stream<AuthState> get authStateChanges {
    _ensureInitialized();
    return SupabaseManager.auth.onAuthStateChange;
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    _ensureInitialized();

    final response = await SupabaseManager.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': role},
    );

    return response;
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    _ensureInitialized();
    return await SupabaseManager.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    _ensureInitialized();
    await SupabaseManager.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    _ensureInitialized();
    await SupabaseManager.auth.resetPasswordForEmail(email);
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    _ensureInitialized();
    await SupabaseManager.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    _ensureInitialized();
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.usersTable)
            .select()
            .eq('id', userId)
            .single();

    return UserModel.fromJson(response);
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    _ensureInitialized();

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await SupabaseManager.client
        .from(SupabaseConstants.usersTable)
        .update(updates)
        .eq('id', userId);
  }
}
