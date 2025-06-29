import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Loads all notifications
  Future<void> loadNotifications() async {
    _setLoading(true);
    _clearError();
    
    try {
      _notifications = await _notificationService.getAllNotifications();
      _unreadCount = await _notificationService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load notifications: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Marks a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final success = await _notificationService.markAsRead(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          _unreadCount = await _notificationService.getUnreadCount();
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _setError('Failed to mark notification as read: $e');
      return false;
    }
  }
  
  /// Marks all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final success = await _notificationService.markAllAsRead();
      if (success) {
        _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
        _unreadCount = 0;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to mark all notifications as read: $e');
      return false;
    }
  }
  
  /// Deletes a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final success = await _notificationService.deleteNotification(notificationId);
      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        _unreadCount = await _notificationService.getUnreadCount();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to delete notification: $e');
      return false;
    }
  }
  
  /// Clears all notifications
  Future<bool> clearAllNotifications() async {
    try {
      final success = await _notificationService.clearAllNotifications();
      if (success) {
        _notifications.clear();
        _unreadCount = 0;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Failed to clear notifications: $e');
      return false;
    }
  }
  
  /// Creates sample notifications for demo
  Future<void> createSampleNotifications() async {
    try {
      await _notificationService.createSampleNotifications();
      await loadNotifications();
    } catch (e) {
      _setError('Failed to create sample notifications: $e');
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
  }
}
