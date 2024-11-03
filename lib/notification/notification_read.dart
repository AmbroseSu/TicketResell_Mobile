import 'package:get_it/get_it.dart';
import 'package:ticket_resell/services/database_service.dart';

class NotificationRead {
  final DatabaseService _databaseService;

  NotificationRead() : _databaseService = GetIt.I<DatabaseService>();

  Future<void> markAsRead(String notificationId) async {
    try {
      await _databaseService.markNotificationAsRead(notificationId);
      print("Notification $notificationId marked as read.");
    } catch (e) {
      print("Failed to mark notification as read: $e");
    }
  }
}
