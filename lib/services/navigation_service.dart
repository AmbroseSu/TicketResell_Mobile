
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ticket_resell/navigation_menu.dart';
import 'package:ticket_resell/screens/chat/allchats_screen.dart';
import 'package:ticket_resell/screens/explore_screen.dart';
import 'package:ticket_resell/screens/login/login.dart';

class NavigationService {

  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginScreen(),
    "/allchat": (context) => AllChatsScreen(),
    "/navigation_menu": (context) => NavigationMenu(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) {
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }

}