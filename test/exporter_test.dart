import 'dart:io';

import 'package:excel_dart/excel_dart.dart';
import 'package:test/test.dart';

import 'package:digital_library/exporter.dart';
import 'package:digital_library/model.dart';

import 'fixtures.dart';

void main() {
  group('Book exporter', () {
    List<Book> books = [generateBook(), generateBook()];

    test('should return excel of books', () async {
      var filePath = await generateLibraryExport(books);
      var fileBytes = File(filePath!).readAsBytesSync();
      var excel = Excel.decodeBytes(fileBytes);
      Sheet sheet = excel['Sheet1'];

      expect(filePath.split('/').last, 'library_export.xlsx');
      expect(sheet.cell(CellIndex.indexByString('A1')).value, 'ISBN');
      expect(sheet.cell(CellIndex.indexByString('B1')).value, 'Title');
      expect(sheet.cell(CellIndex.indexByString('C1')).value, 'Author');
      expect(sheet.cell(CellIndex.indexByString('D1')).value, 'Published year');

      for (var index = 0; index < books.length; index++) {
        var book = books[index];
        var row = index + 2;

        expect(sheet.cell(CellIndex.indexByString('A$row')).value, book.isbn);
        expect(sheet.cell(CellIndex.indexByString('B$row')).value, book.title);
        expect(sheet.cell(CellIndex.indexByString('C$row')).value, book.author);
        expect(
            sheet.cell(CellIndex.indexByString('D$row')).value, book.published);
      }
    });

    test('should return null when no books are provided', () async {
      var filePath = await generateLibraryExport([]);

      expect(filePath, null);
    });
  });
}
