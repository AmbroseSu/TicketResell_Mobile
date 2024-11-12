import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/api/auth_helper.dart';
import 'package:ticket_resell/api/firebase_api.dart';
import 'package:ticket_resell/api/global_variables/fcm_token_manage.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import 'package:ticket_resell/firebase_options.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'package:ticket_resell/notification/notification_screen.dart';
import 'package:ticket_resell/screens/explore_screen.dart';
import 'package:ticket_resell/screens/login/login.dart';
import 'package:ticket_resell/screens/splash_screen.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/database_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/utils.dart';

import 'notification/notification_controller.dart';

final navigatorkey = GlobalKey<NavigatorState>();
//final GetIt sl = GetIt.instance;
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  // Ensure Flutter bindings are initialized before Firebase is called
  isLoggedIn = await isUserLoggedIn();


  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDZvUg8C8r46ASewyC2Sk2AGZh1l6UgWDM",
            authDomain: "ticket-resell-app-33551.firebaseapp.com",
            projectId: "ticket-resell-app-33551",
            storageBucket: "ticket-resell-app-33551.appspot.com",
            messagingSenderId: "663090094318",
            appId: "1:663090094318:web:23468faec61f5d4aa353ff",
            measurementId: "G-PH3VGDM69C"
        )
    );
  }else{
    await Firebase.initializeApp();
  }


  // Initialize Firebase with the specified platform options
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(NotificationController());
  //Get.put(NotificationScreen());
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  //print("Registering DatabaseService");
  await setupFirebase();
  await registerServices();
  UserManager userManager = UserManager();
  await userManager.loadFromPrefs();
  TokenManager tokenManager = TokenManager();
  print("000000000101010101010101010101101010101010110101010101011");
  print(tokenManager.fcmToken);
  print(userManager.id);
  print(userManager.token);
  print(userManager.role);
  print(userManager.fullname);
  print(userManager.email);
  await NotificationScreen();
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Kiểm tra biến `isLoggedIn` để quyết định chuyển hướng
    return isLoggedIn ? null : const RouteSettings(name: '/splashscreen');
  }
}


class MyApp extends StatelessWidget {

  final bool isLoggedIn;
  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;
  late AuthService _authService;
  //late DatabaseService _databaseService;

  MyApp({super.key, required this.isLoggedIn}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    //_databaseService = _getIt.get<DatabaseService>();
  }


  // @override
  // Widget build(BuildContext context) {
  //   return GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: "Travel App",
  //     home: isLoggedIn ? ExploreScreen() : LoginScreen(),
  //     navigatorKey: navigatorkey,
  //     routes: _navigationService.routes,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel App",
      initialRoute: isLoggedIn ? '/' : '/login',
      navigatorKey: navigatorkey,
      getPages: [
        GetPage(name: '/', page: () => NavigationMenu(), middlewares: [AuthMiddleware()]),
        GetPage(name: '/splashscreen', page: () => SplashScreen()),
      ],
    );
  }
}
