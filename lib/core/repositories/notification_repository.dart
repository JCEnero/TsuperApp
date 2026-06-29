import '../config/supabase/supabase_client.dart';
import '../config/supabase/supabase_constants.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  // Get notifications for user
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.notificationsTable)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // Get unread notifications for user
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    final response = await SupabaseManager.client
        .from(SupabaseConstants.notificationsTable)
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);

    return response.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // Create notification
  Future<NotificationModel> createNotification(
    NotificationModel notification,
  ) async {
    final response =
        await SupabaseManager.client
            .from(SupabaseConstants.notificationsTable)
            .insert(notification.toJson())
            .select()
            .single();

    return NotificationModel.fromJson(response);
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.notificationsTable)
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  // Mark all notifications as read for user
  Future<void> markAllAsRead(String userId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.notificationsTable)
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await SupabaseManager.client
        .from(SupabaseConstants.notificationsTable)
        .delete()
        .eq('id', notificationId);
  }
}
