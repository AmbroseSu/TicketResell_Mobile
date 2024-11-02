import 'package:get/get.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs;

  void updateUnreadCount(int count) {
    unreadCount.value = count;
  }
}
