import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordy_app/core/database/app_storage.dart';
import 'package:wordy_app/core/model/word_model.dart';
part 'word_state.dart';

class WordCubit extends Cubit<WordState> {
  final _storage = AppStorage();

  WordCubit() : super(WordInitial()) {
    getWordList();
  }

  Future<void> getWordList() async {
    emit(OnWordProgress());
    try {
      final box = await _storage.openBox();

      print(box.keys);
      final wordList = _storage.getWordList(box);

      emit(OnWordsReceived(wordList));
    } catch (e) {
      emit(OnWordError(e.toString()));
    }
  }

  Future<void> saveWord(WordModel model) async {
    emit(OnWordProgress());
    try {
      final box = await _storage.openBox();
      await _storage.saveWord(box, model);
      emit(OnWordSaved());
      getWordList();
    } catch (e) {
      emit(OnWordError(e.toString()));
    }
  }

  Future<void> editWord(WordModel model) async {
    emit(OnWordProgress());
    try {
      final box = await _storage.openBox();
      await _storage.editWord(box, model);
      emit(OnWordEdited());
      // getWordList();
    } catch (e) {
      emit(OnWordError(e.toString()));
    }
  }

  Future<void> deleteWord(WordModel model) async {
    emit(OnWordProgress());
    try {
      final box = await _storage.openBox();
      await _storage.removeWord(box, model);
      emit(OnWordDeleted());
      getWordList();
    } catch (e) {
      emit(
        OnWordError(e.toString()),
      );
    }
  }
}
