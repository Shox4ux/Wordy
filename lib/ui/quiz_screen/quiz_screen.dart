import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordy_app/core/cubit/word_cubit.dart';
import 'package:wordy_app/ui/res/components/custom_dot_indicators.dart';
import 'package:wordy_app/ui/res/functions/cupitalize_first_letter.dart';
import '../../core/model/word_model.dart';
import '../res/constants/app_colors.dart';
import '../res/constants/app_text_styles.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _pageController = PageController();
  var activeIndex = 0;
  bool _isFront = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        title: const Text("Word Quiz"),
      ),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<WordCubit, WordState>(
            builder: (context, state) {
              if (state is OnWordsReceived) {
                return _pagingView(state.wordList);
              }
              return _whenNoData();
            },
          ),
        ),
      ),
    );
  }

  Column _pagingView(List<WordModel> wordList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 800.h,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: wordList.length,
            itemBuilder: (context, index) => _paageViewItem(wordList[index]),
            onPageChanged: (value) {
              setState(() {
                activeIndex = value;
              });
            },
          ),
        ),
        SizedBox(height: 20.h),
        CustomDotIndicator(
          activeIndex: activeIndex,
          itemCount: wordList.length,
        ),
        Padding(
          padding: EdgeInsets.all(40.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "previous",
                backgroundColor: AppColors.mainColor,
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              FloatingActionButton(
                heroTag: "next",
                backgroundColor: AppColors.mainColor,
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _whenNoData() {
    return const Text("By now there is nothig...");
  }

  Widget _paageViewItem(WordModel model) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: angle),
        duration: const Duration(seconds: 1),
        builder: (context, value, child) {
          if (value >= (pi / 2)) {
            _isFront = false;
          } else {
            _isFront = true;
          }
          return (Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            child: _isFront ? _frotView(model, value) : _backView(model, value),
          ));
        },
      ),
    );
  }

  Widget _frotView(WordModel model, double rotationAngle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 80.h, horizontal: 50.w),
      padding: EdgeInsets.all(40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${model.word}".cupitalizeFirstLetter(),
            style: AppTextStyles.wordText.copyWith(
              fontSize: 52.sp,
            ),
          ),
          Text(
            "[ ${model.transcription} ]",
            style: AppTextStyles.transcriptText.copyWith(
              fontSize: 42.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backView(WordModel model, double rotationAngle) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 80.h, horizontal: 50.w),
        padding: EdgeInsets.all(40.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Definision:",
                  style: AppTextStyles.wordText.copyWith(
                    fontSize: 32.sp,
                  ),
                ),
                Text(
                  model.definition!.cupitalizeFirstLetter(),
                  style: AppTextStyles.transcriptText.copyWith(),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Example:",
                  style: AppTextStyles.wordText.copyWith(
                    fontSize: 32.sp,
                  ),
                ),
                Text(
                  model.example!.cupitalizeFirstLetter(),
                  style: AppTextStyles.transcriptText.copyWith(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
