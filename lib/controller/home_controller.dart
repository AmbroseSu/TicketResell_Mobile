import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController get instance => Get.find();

  final carsousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carsousalCurrentIndex.value = index;
  }
}