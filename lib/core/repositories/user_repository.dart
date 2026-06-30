import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.usersTable)
              .select()
              .eq('id', userId)
              .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final response =
          await SupabaseManager.client
              .from(SupabaseConstants.usersTable)
              .select()
              .eq('email', email)
              .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Create user
  Future<UserModel> createUser(UserModel user) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.usersTable)
            .insert(user.toJson())
            .select()
            .single();

    return UserModel.fromJson(response);
  }

  // Update user
  Future<UserModel> updateUser(UserModel user) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.usersTable)
            .update(user.toJson())
            .eq('id', user.id)
            .select()
            .single();

    return UserModel.fromJson(response);
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.usersTable)
        .delete()
        .eq('id', userId);
  }
}
