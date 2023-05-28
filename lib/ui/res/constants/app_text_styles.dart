import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle splashText = GoogleFonts.poppins(
    fontSize: 84.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      const Shadow(
        color: Colors.black,
        offset: Offset(1, 1),
        blurRadius: 4,
      )
    ],
  );

  static TextStyle appBarText = GoogleFonts.poppins(
    fontSize: 48.sp,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle wordText = GoogleFonts.poppins(
    fontSize: 32.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle defText = GoogleFonts.poppins(
    fontSize: 30.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle exapleText = GoogleFonts.poppins(
    fontSize: 30.sp,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static TextStyle transcriptText = GoogleFonts.poppins(
    fontSize: 28.sp,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subTextStule = GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    shadows: [
      const Shadow(
        color: Colors.black,
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ],
  );
}
