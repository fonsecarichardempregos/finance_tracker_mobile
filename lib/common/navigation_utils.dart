import 'package:flutter/material.dart';

class NavigationUtils {
  static final NavigationUtils _instance = NavigationUtils.internal();

  factory NavigationUtils() => _instance;

  NavigationUtils.internal();

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> push(Route routeName) {
    return navigatorKey.currentState!.push(routeName);
  }

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushReplacementNamed(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  Future<dynamic> pushAndRemoveUntil(Route routeName) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
      routeName,
          (route) => false,
    );
  }

  // Future<dynamic> logoutUser() {
  //   //TODO: COLOCAR DIALOG/TOAST
  //   showInSnackBar(
  //     navigatorKey.currentContext,
  //     'As informações da sua carteira estão indisponíveis no momento.\n'
  //     'Por favor tente novamente mais tarde.',
  //
  //     color: Colors.black87,
  //   );
  //
  //   // logout(navigatorKey.currentContext);
  //   //
  //   // return navigatorKey.currentState!.pushAndRemoveUntil(
  //   //   MaterialPageRoute(builder: (_) => LoginScreen()),
  //   //   (route) => false,
  //   // );
  // }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
    );
  }

  void showMyDialog() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Text('Hello'),
          ),
        ));
  }
}