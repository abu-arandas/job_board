import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum NotificationType {
  @JsonValue('job_alert')
  jobAlert,
  @JsonValue('application_update')
  applicationUpdate,
  @JsonValue('new_message')
  newMessage,
  @JsonValue('system')
  system,
}

@JsonSerializable()
class AppNotification {

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) => AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );

  String get typeDisplayName {
    switch (type) {
      case NotificationType.jobAlert:
        return 'Job Alert';
      case NotificationType.applicationUpdate:
        return 'Application Update';
      case NotificationType.newMessage:
        return 'New Message';
      case NotificationType.system:
        return 'System';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppNotification{id: $id, title: $title, type: $type, isRead: $isRead}';
}
