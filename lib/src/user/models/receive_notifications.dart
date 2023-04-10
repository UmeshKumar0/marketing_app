class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationResponse {
  /// Constructs an instance of [NotificationResponse]
  const NotificationResponse({
    required this.notificationResponseType,
    this.id,
    this.actionId,
    this.input,
    this.payload,
  });

  /// The notification's id.
  ///
  /// This is nullable as support for this only supported for notifications
  /// created using version 10 or newer of this plugin.
  final int? id;

  /// The id of the action that was triggered.
  final String? actionId;

  /// The value of the input field if the notification action had an input
  /// field.
  final String? input;

  /// The notification's payload.
  final String? payload;

  /// The notification response type.
  final NotificationResponseType notificationResponseType;
}

enum NotificationResponseType {
  /// Indicates that a user has selected a notification.
  selectedNotification,

  /// Indicates the a user has selected a notification action.
  selectedNotificationAction,
}
