import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordy_app/core/model/word_model.dart';
import 'package:wordy_app/ui/res/constants/app_text_styles.dart';
import 'package:wordy_app/ui/res/main_navigation.dart';
import '../../core/cubit/word_cubit.dart';
import '../res/constants/app_colors.dart';
import '../res/functions/random_text_generator.dart';
import '../res/functions/show_toast.dart';

class AddEditScreen extends StatefulWidget {
  WordModel? model;

  AddEditScreen(this.model, {super.key});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _wordController = TextEditingController();
  final _transcriptionController = TextEditingController();
  final _definitionController = TextEditingController();
  final _exampleController = TextEditingController();
  var _isFilled = false;

  @override
  void initState() {
    super.initState();
    _definitionController.text = widget.model?.definition ?? "";
    _exampleController.text = widget.model?.example ?? "";
    _transcriptionController.text = widget.model?.transcription ?? "";
    _wordController.text = widget.model?.word ?? "";
    _checkFields();
  }

  void _checkFields() {
    if (_wordController.text.isNotEmpty &&
        _definitionController.text.isNotEmpty &&
        _exampleController.text.isNotEmpty &&
        _transcriptionController.text.isNotEmpty) {
      setState(() {
        _isFilled = true;
      });
    } else {
      setState(() {
        _isFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        title: const Text("Word Laboratory"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          context.read<WordCubit>().getWordList();
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              30.w,
            ),
            child: SingleChildScrollView(
              child: BlocConsumer<WordCubit, WordState>(
                listener: (context, state) {
                  if (state is OnWordSaved) {
                    showToast("Word succesfully saved");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.main,
                      (route) => false,
                    );
                  }

                  if (state is OnWordDeleted) {
                    showToast("Word succesfully deleted");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.main,
                      (route) => false,
                    );
                  }

                  if (state is OnWordEdited) {
                    showToast("Word succesfully edited");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.main,
                      (route) => false,
                    );
                    context.read<WordCubit>().getWordList();
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<WordCubit, WordState>(
                    builder: (context, state) {
                      if (widget.model != null) {
                        final newWord = WordModel(
                          id: widget.model?.id,
                          word: _wordController.text,
                          definition: _definitionController.text,
                          example: _exampleController.text,
                          transcription: _transcriptionController.text,
                        );
                        return _wordEditing(context, newWord);
                      } else {
                        return _wordSaving(context);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wordEditing(BuildContext context, WordModel model) {
    return Column(
      children: [
        SizedBox(height: 150.h),
        TextField(
          onChanged: (value) => _checkFields(),
          textInputAction: TextInputAction.next,
          controller: _wordController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Word",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) => _checkFields(),
          textInputAction: TextInputAction.next,
          controller: _transcriptionController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Transcription",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) => _checkFields(),
          textInputAction: TextInputAction.next,
          controller: _definitionController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Definition",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) => _checkFields(),
          textInputAction: TextInputAction.done,
          controller: _exampleController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Example",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 100.h),
        _isFilled
            ? ElevatedButton(
                onPressed: () {
                  context.read<WordCubit>().editWord(model);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.80,
                    MediaQuery.of(context).size.width * 0.15,
                  ),
                ),
                child: Text(
                  "Edit the Word",
                  style: AppTextStyles.buttonText.copyWith(fontSize: 36.sp),
                ),
              )
            : ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.80,
                    MediaQuery.of(context).size.width * 0.15,
                  ),
                ),
                child: Text(
                  "Edit the Word",
                  style: AppTextStyles.buttonText.copyWith(fontSize: 36.sp),
                ),
              ),
      ],
    );
  }

  Widget _wordSaving(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 150.h),
        TextField(
          onChanged: (value) {
            _checkFields();
          },
          textInputAction: TextInputAction.next,
          controller: _wordController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Word",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) {
            _checkFields();
          },
          textInputAction: TextInputAction.next,
          controller: _transcriptionController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Transcription",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) {
            _checkFields();
          },
          textInputAction: TextInputAction.next,
          controller: _definitionController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Definition",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        TextField(
          onChanged: (value) {
            _checkFields();
          },
          textInputAction: TextInputAction.done,
          controller: _exampleController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Example",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.h),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 100.h),
        _isFilled
            ? BlocBuilder<WordCubit, WordState>(
                builder: (context, state) {
                  if (state is OnWordProgress) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final wordId = getRandomString(10);
                      context.read<WordCubit>().saveWord(WordModel(
                            id: wordId,
                            word: _wordController.text,
                            transcription: _transcriptionController.text,
                            definition: _definitionController.text,
                            example: _exampleController.text,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.80,
                        MediaQuery.of(context).size.width * 0.15,
                      ),
                    ),
                    child: Text(
                      "Save the Word",
                      style: AppTextStyles.buttonText.copyWith(fontSize: 36.sp),
                    ),
                  );
                },
              )
            : ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.80,
                    MediaQuery.of(context).size.width * 0.15,
                  ),
                ),
                child: Text(
                  "Save the Word",
                  style: AppTextStyles.buttonText.copyWith(fontSize: 36.sp),
                ),
              ),
      ],
    );
  }
}
