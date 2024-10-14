import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:ticket_resell/screens/splash_screen.dart';
import 'package:ticket_resell/services/auth_service.dart';
import 'package:ticket_resell/services/navigation_service.dart';
import 'package:ticket_resell/utils.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await setup();
  // Ensure Flutter bindings are initialized before Firebase is called
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}


class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;
  late AuthService _authService;

  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel App",
      home: SplashScreen(),
      navigatorKey: _navigationService.navigatorKey,
      routes: _navigationService.routes,
    );
  }
}
