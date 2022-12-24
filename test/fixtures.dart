import 'dart:math';

import 'package:private_library/model.dart';

String generateID() {
  var codeUnits = List.generate(8, (index) => Random().nextInt(33) + 89);
  return String.fromCharCodes(codeUnits);
}

String generateISBN() {
  var numbers = List.generate(11, (index) => Random().nextInt(9));
  return numbers.join();
}

String generateAuthor() {
  return 'Author von Authorious${generateID()}';
}

String generateTitle() {
  return 'Best book in the world ${generateID()}';
}

int generatePublishYear() {
  return (1000 * Random().nextInt(3) +
      100 * Random().nextInt(10) +
      10 * Random().nextInt(10) +
      Random().nextInt(10));
}

Book generateBook() {
  return Book(
      generateISBN(), generateTitle(), generateTitle(), generatePublishYear());
}
