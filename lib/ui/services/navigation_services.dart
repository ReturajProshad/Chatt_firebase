import 'package:flutter/material.dart';

class navigationService {
  late GlobalKey<NavigatorState> navigatorkey;
  static navigationService instance = navigationService();
  navigationService() {
    navigatorkey = GlobalKey<NavigatorState>();
  }
  Future<dynamic> navigatorRepalacement(String _routeName) {
    return navigatorkey.currentState!.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateToPage(String _routeName) {
    return navigatorkey.currentState!.pushNamed(_routeName);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _route) {
    return navigatorkey.currentState!.push(_route);
  }

  void goBack() {
    return navigatorkey.currentState!.pop();
  }
}
