import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';
  static const String _unreadCountKey = 'unread_notifications_count';

  /// Gets all notifications
  Future<List<AppNotification>> getAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];
      
      return notificationsJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return AppNotification.fromJson(data);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      return [];
    }
  }

  /// Adds a new notification
  Future<bool> addNotification(AppNotification notification) async {
    try {
      final notifications = await getAllNotifications();
      notifications.insert(0, notification);
      
      // Keep only the latest 100 notifications
      if (notifications.length > 100) {
        notifications.removeRange(100, notifications.length);
      }
      
      await _saveNotifications(notifications);
      await _updateUnreadCount();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Marks a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final notifications = await getAllNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      
      if (index != -1 && !notifications[index].isRead) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
        await _updateUnreadCount();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Marks all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final notifications = await getAllNotifications();
      final updatedNotifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
      
      await _saveNotifications(updatedNotifications);
      await _updateUnreadCount();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_unreadCountKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Deletes a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final notifications = await getAllNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      
      await _saveNotifications(notifications);
      await _updateUnreadCount();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clears all notifications
  Future<bool> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
      await prefs.setInt(_unreadCountKey, 0);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Creates sample notifications for demo purposes
  Future<void> createSampleNotifications() async {
    final sampleNotifications = [
      AppNotification(
        id: '1',
        title: 'New Job Match!',
        message: 'A new Flutter Developer position at TechCorp matches your profile.',
        type: NotificationType.jobAlert,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        data: {'jobId': '1'},
      ),
      AppNotification(
        id: '2',
        title: 'Application Update',
        message: 'Your application for Senior Flutter Developer has been reviewed.',
        type: NotificationType.applicationUpdate,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        data: {'jobId': '1', 'status': 'reviewed'},
      ),
      AppNotification(
        id: '3',
        title: 'Profile Views',
        message: 'Your profile has been viewed 5 times this week.',
        type: NotificationType.system,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      AppNotification(
        id: '4',
        title: 'New Message',
        message: 'You have a new message from StartupXYZ recruiter.',
        type: NotificationType.newMessage,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        data: {'senderId': 'recruiter_123'},
      ),
    ];

    for (final notification in sampleNotifications) {
      await addNotification(notification);
    }
  }

  Future<void> _saveNotifications(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = notifications.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notificationsKey, notificationsJson);
  }

  Future<void> _updateUnreadCount() async {
    final notifications = await getAllNotifications();
    final unreadCount = notifications.where((n) => !n.isRead).length;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadCountKey, unreadCount);
  }
}
