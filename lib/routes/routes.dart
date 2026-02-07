import 'package:flutter/material.dart';
import 'package:flutter_final_app/screens/login_screen.dart';
import 'package:flutter_final_app/screens/splash_screen.dart';

// Importa tus pantallas


class AppRoutes {
  // Nombres de rutas
  static const String splash = '/';
  static const String login = './login';

  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    splash: (context) => const SplashScreen(),
    

  };
}
