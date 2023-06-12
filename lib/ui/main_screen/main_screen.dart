import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordy_app/core/model/word_model.dart';
import 'package:wordy_app/ui/add_edit_screen/add_edit_screen.dart';
import 'package:wordy_app/ui/quiz_screen/quiz_screen.dart';
import 'package:wordy_app/ui/res/functions/cupitalize_first_letter.dart';
import 'package:wordy_app/ui/res/functions/sort_word_list_by_time.dart';
import '../../core/cubit/word_cubit.dart';
import '../res/constants/app_colors.dart';
import '../res/constants/app_text_styles.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../res/functions/show_toast.dart';

int? selectedWordIndex;
List<WordModel> wordList = [];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        backgroundColor: AppColors.mainColor,
        icon: Icons.menu,
        activeIcon: Icons.close,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        spacing: 10.h,
        spaceBetweenChildren: 20.h,
        renderOverlay: true,
        direction: SpeedDialDirection.up,
        heroTag: "why caused",
        animationCurve: Curves.easeInOut,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Add word",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditScreen(null),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.quiz),
            label: "Take quiz",
            onTap: () {
              wordList.isNotEmpty
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    )
                  : showToast("Add words");
              ;
            },
          )
        ],
      ),
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          "Welcome to Wordy",
          style: AppTextStyles.appBarText,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<WordCubit, WordState>(
        builder: (context, state) {
          return BlocBuilder<WordCubit, WordState>(
            builder: (context, state) {
              if (state is WordInitial || state is OnWordProgress) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                  ),
                );
              }
              if (state is OnWordsReceived) {
                wordList = state.wordList;

                // final reflected = wordList;
                return _listPart(context, sortWordsById(wordList));
              }
              return const Center(child: Text("Ups, something went wrong"));
            },
          );
        },
      ),
    );
  }

  Widget _listPart(BuildContext context, List<WordModel> wordList) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              wordList.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              itemCount: wordList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (selectedWordIndex == index) {
                                      setState(() {
                                        selectedWordIndex = null;
                                      });
                                    } else {
                                      setState(() {
                                        selectedWordIndex = index;
                                      });
                                    }
                                  },
                                  child: wordItem(wordList[index],
                                      selectedWordIndex == index),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "It seems there is nothing\n   please add the word...",
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget wordItem(WordModel wordModel, bool isSelected) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15.sp),
      ),
      duration: const Duration(seconds: 1),
      child: !isSelected
          ? _unSelectedWordItem(wordModel)
          : _selectedWordItem(wordModel),
    );
  }

  Container _selectedWordItem(WordModel wordModel) {
    return Container(
      padding:
          EdgeInsets.only(top: 20.h, bottom: 30.h, left: 40.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditScreen(wordModel),
                        ),
                      );
                      setState(() {
                        selectedWordIndex = null;
                      });
                    },
                    child: CircleAvatar(
                      radius: 25.h,
                      backgroundColor: AppColors.mainColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.h),
                        child: Icon(
                          Icons.edit,
                          size: 30.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      _showMyDialog(wordModel);
                    },
                    child: CircleAvatar(
                      radius: 25.h,
                      backgroundColor: AppColors.redColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.h),
                        child: Icon(
                          Icons.delete,
                          size: 30.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    wordModel.word!.cupitalizeFirstLetter(),
                    style: AppTextStyles.wordText,
                  ),
                  SizedBox(width: 20.w),
                  Flexible(
                    child: Text(
                      "[ ${wordModel.transcription!} ]",
                      style: AppTextStyles.transcriptText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Definision: ",
                      style: AppTextStyles.transcriptText
                          .copyWith(fontSize: 32.sp),
                    ),
                    TextSpan(
                      text: wordModel.definition!.cupitalizeFirstLetter(),
                      style: AppTextStyles.defText,
                    )
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Example: ",
                      style: AppTextStyles.transcriptText
                          .copyWith(fontSize: 32.sp),
                    ),
                    TextSpan(
                      text: wordModel.example!.cupitalizeFirstLetter(),
                      style: AppTextStyles.exapleText
                          .copyWith(color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _unSelectedWordItem(WordModel wordModel) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 40.w),
      child: Row(
        children: [
          Text(
            wordModel.word!.cupitalizeFirstLetter(),
            style: AppTextStyles.wordText,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 20.w),
          Flexible(
            child: Text(
              "[ ${wordModel.transcription!} ]",
              style: AppTextStyles.transcriptText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(WordModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 30.h, left: 40.w),
          contentPadding: EdgeInsets.only(left: 40.w, bottom: 20.h),
          title: Text(
            'Deleting the word',
            style: AppTextStyles.wordText.copyWith(
              fontSize: 42.sp,
            ),
          ),
          content: Text('Are you sure about this?',
              style: AppTextStyles.wordText.copyWith(
                fontSize: 32.sp,
                color: AppColors.redColor,
              )),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Yes',
                      style: AppTextStyles.defText.copyWith(
                        fontSize: 32.sp,
                        color: AppColors.mainColor,
                      )),
                  onPressed: () {
                    context.read<WordCubit>().deleteWord(model);
                    Navigator.of(context).pop();

                    setState(() {
                      selectedWordIndex = null;
                    });
                  },
                ),
                TextButton(
                  child: Text('No',
                      style: AppTextStyles.defText.copyWith(
                        fontSize: 32.sp,
                        color: AppColors.mainColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
