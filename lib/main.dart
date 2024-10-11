import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_resell/screens/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter bindings are initialized before Firebase is called
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDnxu7wQyToc7bD_gv87DBafJh_kJF4adg",
            authDomain: "ticket-resell-10bfb.firebaseapp.com",
            projectId: "ticket-resell-10bfb",
            storageBucket: "ticket-resell-10bfb.appspot.com",
            messagingSenderId: "500394411761",
            appId: "1:500394411761:web:1b7bd9803135eedaf78b50",
            measurementId: "G-FZVYMFDQST"
        )
    );
  }else{
    await Firebase.initializeApp();
  }


  // Initialize Firebase with the specified platform options
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel App",
      home: SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
