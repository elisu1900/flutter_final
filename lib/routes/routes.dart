import 'package:flutter/material.dart';
import 'package:flutter_final_app/screens/login_screen.dart';
import 'package:flutter_final_app/screens/splash_screen.dart';
import 'package:flutter_final_app/screens/register_screen.dart';
import 'package:flutter_final_app/screens/personal_information_screen.dart';
import 'package:flutter_final_app/screens/body_measures_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = './login';
  static const String register = '/register';
  static const String register2 = '/register2';
  static const String register3 = '/register3';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    splash: (context) => const SplashScreen(),
    register: (context) => const RegisterScreen(),
    register2: (context) => const PersonalInfoScreen(),
    register3: (context) => const BodyMeasuresScreen(),
    
  };
}
