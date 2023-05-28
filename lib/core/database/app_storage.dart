import 'package:hive/hive.dart';
import 'package:wordy_app/core/model/word_model.dart';

abstract class AppStorageLogic {
  Future<Box> openBox();
  List<WordModel> getWordList(Box box);
  Future<void> saveWord(Box box, WordModel model);
  Future<void> editWord(Box box, WordModel model);
  Future<void> removeWord(Box box, WordModel model);
  Future<void> clearWordList(Box box);
  Future<void> closeBox(Box box);
}

class AppStorage extends AppStorageLogic {
  String boxName = "wordBox";

  @override
  Future<Box> openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WordAdapter());
    }
    Box box = await Hive.openBox<WordModel>(boxName);
    return box;
  }

  @override
  Future<void> saveWord(Box box, WordModel model) async {
    await box.put(model.id, model);
  }

  @override
  List<WordModel> getWordList(Box box) {
    return box.values.toList() as List<WordModel>;
  }

  @override
  Future<void> editWord(Box box, WordModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> removeWord(Box box, WordModel model) async {
    await box.delete(model.id);
  }

  @override
  Future<void> clearWordList(Box box) async {
    await box.deleteFromDisk();
  }

  @override
  Future<void> closeBox(Box box) async {
    await box.close();
  }
}
