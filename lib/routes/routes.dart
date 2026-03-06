import 'package:flutter/material.dart';
import 'package:flutter_final_app/models/dieta.dart';
import 'package:flutter_final_app/screens/body_measures_screen.dart';
import 'package:flutter_final_app/screens/dieta_view_screen.dart';
import 'package:flutter_final_app/screens/goal_activity_screen.dart';
import 'package:flutter_final_app/screens/login_screen.dart';
import 'package:flutter_final_app/screens/modify_dieta_screen.dart';
import 'package:flutter_final_app/screens/personal_information_screen.dart';
import 'package:flutter_final_app/screens/register_screen.dart';
import 'package:flutter_final_app/screens/splash_screen.dart';
import 'package:flutter_final_app/screens/view_dietas_screen.dart';
import 'package:flutter_final_app/services/local_storage_service.dart';

class AppRoutes {
  static const String splash      = '/';
  static const String login       = '/login';
  static const String register    = '/register';
  static const String register2   = '/register2';
  static const String register3   = '/register3';
  static const String register4   = '/register4';
  static const String verDietas   = '/ver-dietas';
  static const String dietaView   = '/dieta-view';
  static const String modifyDieta = '/modify-dieta';
  static const String revision    = '/revision';   // ← nueva

  static final Map<String, WidgetBuilder> routes = {
    splash:    (_) => const SplashScreen(),
    login:     (_) => const LoginScreen(),
    register:  (_) => const RegisterScreen(),
    register2: (_) => const PersonalInfoScreen(),
    register3: (_) => const BodyMeasuresScreen(),
    register4: (_) => const GoalsActivityScreen(),
    verDietas: (_) => const VerDietasScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dietaView:
        final dieta = settings.arguments as Dieta;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => DietaViewScreen(dieta: dieta),
        );
      case modifyDieta:
        final dieta = settings.arguments as Dieta;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ModifyDietaScreen(dieta: dieta),
        );
      default:
        return null;
    }
  }
}
