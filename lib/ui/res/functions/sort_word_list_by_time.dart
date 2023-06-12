import 'package:wordy_app/core/model/word_model.dart';

List<WordModel> sortWordsById(List<WordModel> data) {
  data.sort((a, b) {
    DateTime datetimeA = DateTime.parse(a.id!);
    DateTime datetimeB = DateTime.parse(b.id!);
    return datetimeA.compareTo(datetimeB);
  });

  return data;
}
