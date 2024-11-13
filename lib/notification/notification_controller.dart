import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/services/database_service.dart';

class NotificationController extends GetxController {
  var unreadCount = 0.obs;

  void updateUnreadCount(int count) {
    unreadCount.value = count;
  }


}
