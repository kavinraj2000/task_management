import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

Future<void> _handlePriorityNotification(
  Map<String, dynamic> task,
  DateTime dueDate,
  String priority,
) async {
  final title = task['title'];

  String message;
  int notificationId;

  switch (priority) {
    case 'high':
      message = "URGENT: '$title' is overdue!";
      notificationId = task['id'].hashCode;
      break;

    case 'medium':
      message = "⚠️ '$title' is nearing deadline";
      notificationId = task['id'].hashCode;
      break;

    default:
      message = "Reminder: '$title' is pending";
      notificationId = task['id'].hashCode;
  }

  await notifications.show(
    id: notificationId,
    title: "Task Alert",
    body: message,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}
