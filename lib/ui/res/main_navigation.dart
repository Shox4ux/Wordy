import 'package:flutter/cupertino.dart';
import 'package:wordy_app/ui/main_screen/main_screen.dart';

import '../quiz_screen/quiz_screen.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.main: (context) => const MainScreen(),
    RouteNames.quiz: (context) => const QuizScreen(),
  };
}

abstract class RouteNames {
  static const main = "main";
  static const quiz = "quiz";

  // static const addEditScreen = "addEditScreen";
}
