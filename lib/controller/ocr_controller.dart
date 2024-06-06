import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

List<WordBox> getText(RecognizedText recognisedText) {
  List<WordBox> wordBoxes = [];
  for (TextBlock block in recognisedText.blocks) {
    for (TextLine line in block.lines) {
      for (TextElement element in line.elements) {
        Rect boundingBox = element.boundingBox;
        wordBoxes.add(WordBox(element.text, boundingBox, element.cornerPoints));
      }
    }
  }
  return wordBoxes;
}

List<Line> constructLineWithBoundingPolygon(List<WordBox> wordBoxes) {
  List<Line> lines = [];
  List<WordBox> currentLine = [];

  wordBoxes.sort(
          (a, b) => a.boundingBox.topLeft.dy.compareTo(b.boundingBox.topLeft.dy));

  for (int i = 0; i < wordBoxes.length; i++) {
    WordBox wordBox = wordBoxes[i];

    if (currentLine.isEmpty) {
      currentLine.add(wordBox);
    } else {
      if ((wordBox.boundingBox.top - currentLine.first.boundingBox.top).abs() <=
          10) {
        currentLine.add(wordBox);
      } else {
        lines.add(Line(List.from(currentLine)));
        currentLine.clear();
        currentLine.add(wordBox);
      }
    }
  }
  if (currentLine.isNotEmpty) {
    lines.add(Line(List.from(currentLine)));
  }
  return lines;
}

List<Line> arrangeWordsInOrder(List<Line> lines) {
  lines.forEach((line) {
    line.wordBoxes
        .sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
  });
  return lines;
}

void readTextFromImage(
    String imagePath,
    TextEditingController dateController,
    TextEditingController priceController,
    ) async {
  String price = "";
  String date = "";

  final inputImage = InputImage.fromFilePath(imagePath);

  final textDetector = TextRecognizer();

  final RecognizedText recognizedText =
  await textDetector.processImage(inputImage);

  List<WordBox> wordBoxes = getText(recognizedText);

  List<Line> lines = constructLineWithBoundingPolygon(wordBoxes);

  lines = arrangeWordsInOrder(lines);

  for (Line line in lines) {
    String text =
    line.wordBoxes.map((e) => e.text).join(' ').toLowerCase().trim();

    if (text.contains('toplam') || text.contains('total')) {
      RegExp amountPattern = RegExp(r'[\d,.]+');
      Match? match = amountPattern.firstMatch(text);
      if (match != null) {
        price = match.group(0)!;
        price = fixNumberFormat(price);
      }
    } else if (text.contains('tarih') ||
        text.contains('date') ||
        text.contains('taríh')) {
      RegExp datePattern = RegExp(r'(\d{2}).(\d{2}).(\d{4})');
      Match? dateMatch = datePattern.firstMatch(text);
      if (dateMatch != null) {
        date =
        "${dateMatch.group(1)}/${dateMatch.group(2)}/${dateMatch.group(3)}";
      }
    }
  }
  dateController.text = date;
  priceController.text = price;

  textDetector.close();
}

String fixNumberFormat(String amount) {
  return amount.replaceAll(',', '.').replaceAll(RegExp(r'\s+'), '');
}

class WordBox {
  String text;
  Rect boundingBox;
  List<Point<int>> vertices;

  WordBox(this.text, this.boundingBox, this.vertices);
}

class Line {
  List<WordBox> wordBoxes;

  Line(this.wordBoxes);
}
