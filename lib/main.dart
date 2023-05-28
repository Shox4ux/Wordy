import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wordy_app/core/cubit/word_cubit.dart';
import 'package:wordy_app/ui/res/constants/app_colors.dart';
import 'package:wordy_app/ui/res/main_navigation.dart';
import 'package:wordy_app/ui/splash_screen/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = MainNavigation();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WordCubit(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(720, 1600),
        builder: (context, child) => MaterialApp(
          theme: ThemeData(
            primaryColor: AppColors.mainColor,
            focusColor: AppColors.mainColor,
          ),
          debugShowCheckedModeBanner: false,
          routes: navigation.routes,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
