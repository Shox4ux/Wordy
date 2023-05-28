import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/app_colors.dart';

class CustomDotIndicator extends StatelessWidget {
  const CustomDotIndicator({
    super.key,
    required this.activeIndex,
    required this.itemCount,
  });

  final int activeIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return dotIndicator();
  }

  Widget dotIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: itemCount,
      effect: ScrollingDotsEffect(
        spacing: 16.w,
        activeDotScale: 1.8.h,
        activeDotColor: AppColors.mainColor,
        dotColor: Colors.grey,
        dotHeight: 10.h,
        dotWidth: 10.w,
      ),
    );
  }
}
