import 'package:hive/hive.dart';

class WordModel {
  String? id;
  String? word;
  String? transcription;
  String? definition;
  String? example;

  WordModel({
    required this.id,
    required this.word,
    required this.transcription,
    required this.definition,
    required this.example,
  });

  WordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    transcription = json['transcription'];
    definition = json['definition'];
    example = json['example'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['word'] = word;
    data['transcription'] = transcription;
    data['definition'] = definition;
    data['example'] = example;
    return data;
  }
}

class WordAdapter extends TypeAdapter<WordModel> {
  @override
  WordModel read(BinaryReader reader) {
    final id = reader.readString();
    final word = reader.readString();
    final transcription = reader.readString();

    final definition = reader.readString();
    final example = reader.readString();

    return WordModel(
      id: id,
      word: word,
      transcription: transcription,
      definition: definition,
      example: example,
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, WordModel obj) {
    writer.writeString(obj.id!);
    writer.writeString(obj.word!);
    writer.writeString(obj.transcription!);
    writer.writeString(obj.definition!);
    writer.writeString(obj.example!);
  }
}
