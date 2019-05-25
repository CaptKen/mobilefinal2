import 'dart:io';

import 'package:path_provider/path_provider.dart';

class QuoteText {
  Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get myfile async {
    final path = await _path;
    return File('$path/userquote.txt');
  }

  Future<File> writeText(String text) async {
    final file = await myfile;

    // Write the file
    return file.writeAsString('$text');
  }

  Future<String> readText() async {
    try {
      final file = await myfile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }
}
