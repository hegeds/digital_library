import 'dart:io';
import 'package:excel_dart/excel_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import './model.dart';

Future<String?> generateLibraryExport(List<Book> books) async {
  if (books.isEmpty) {
    return null;
  }

  Excel excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  sheet.appendRow(['ISBN', 'Title', 'Authors', 'Published year']);
  for (Book book in books) {
    var bookRow = [
      book.isbn,
      book.title,
      book.getAuthorsAsString(),
      book.published
    ];
    sheet.appendRow(bookRow);
  }

  Directory tempDir = await getTemporaryDirectory();
  String filePath = '${tempDir.path}/library_export.xlsx';

  var fileBytes = excel.save();
  File(join(filePath))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);

  return filePath;
}
