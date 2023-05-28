part of 'word_cubit.dart';

@immutable
abstract class WordState extends Equatable {}

class WordInitial extends WordState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnWordProgress extends WordState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnWordsReceived extends WordState {
  final List<WordModel> wordList;
  OnWordsReceived(this.wordList);
  @override
  List<Object?> get props => [wordList];
}

class OnWordSaved extends WordState {
  @override
  List<Object?> get props => [];
}

class OnWordEdited extends WordState {
  @override
  List<Object?> get props => [];
}

class OnWordError extends WordState {
  final String error;
  OnWordError(this.error);
  @override
  List<Object?> get props => [error];
}

class OnWordDeleted extends WordState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
