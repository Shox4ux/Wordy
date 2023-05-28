extension MyExtension on String {
  String cupitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
