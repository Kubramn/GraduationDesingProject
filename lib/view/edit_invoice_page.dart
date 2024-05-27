import 'dart:io';
import 'dart:math';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class EditInvoicePage extends StatefulWidget {
  final String imagePath;
  const EditInvoicePage({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditInvoicePage> createState() => _EditInvoicePageState();
}

class _EditInvoicePageState extends State<EditInvoicePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Icon categoryIcon = Icon(
    Icons.category_outlined,
    color: Color.fromARGB(255, 49, 102, 101),
  );

  @override
  void initState() {
    super.initState();
    _readTextFromImage(); // Sayfa açıldığında metni okumayı başlat
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          highlightColor: Color.fromARGB(50, 49, 102, 101),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 30,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(
                File(widget.imagePath),
                //height: 300,
                //width: 300,
              ),
              SizedBox(height: screenHeight * 0.06),
              invoiceInfoTextField(
                titleController,
                "Title",
                Icons.title,
              ),
              SizedBox(height: screenHeight * 0.02),
              invoiceInfoTextField(
                descriptionController,
                "Description",
                Icons.description_outlined,
              ),
              SizedBox(height: screenHeight * 0.02),
              categoryDropdownMenu(),
              SizedBox(height: screenHeight * 0.02),
              invoiceInfoTextField(
                dateController,
                "Date",
                Icons.date_range,
              ),
              SizedBox(height: screenHeight * 0.02),
              invoiceInfoTextField(
                priceController,
                "Price",
                Icons.price_change_outlined,
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () => addExpense(),
                child: Text(
                  "Add Expense",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 157, 203, 201),
                  foregroundColor: Color.fromARGB(255, 49, 102, 101),
                  fixedSize: Size(500, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryDropdownMenu() {
    return DropdownMenu<String>(
      controller: categoryController,
      leadingIcon: categoryIcon,
      trailingIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Color.fromARGB(255, 49, 102, 101),
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Color.fromARGB(255, 49, 102, 101),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle:
            TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      hintText: "Category",
      width: 394,
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        alignment: Alignment.bottomLeft,
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onSelected: (_) {
        setState(() {});
        switch (categoryController.text) {
          case "Travel and Transportation":
            categoryIcon = Icon(
              Icons.emoji_transportation,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Meals and Entertainment":
            categoryIcon = Icon(
              Icons.fastfood_outlined,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Office Supplies and Equipment":
            categoryIcon = Icon(
              Icons.meeting_room_outlined,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
          case "Other Expenses":
            categoryIcon = Icon(
              Icons.attach_money,
              color: Color.fromARGB(255, 49, 102, 101),
            );
            break;
        }
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: "Travel and Transportation",
          label: "Travel and Transportation",
          leadingIcon: Icon(
            Icons.emoji_transportation,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Meals and Entertainment",
          label: "Meals and Entertainment",
          leadingIcon: Icon(
            Icons.fastfood_outlined,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Office Supplies and Equipment",
          label: "Office Supplies and Equipment",
          leadingIcon: Icon(
            Icons.meeting_room_outlined,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
        DropdownMenuEntry(
          value: "Other Expenses",
          label: "Other Expenses",
          leadingIcon: Icon(
            Icons.attach_money,
            color: Color.fromARGB(255, 49, 102, 101),
          ),
        ),
      ],
    );
  }

  Widget invoiceInfoTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black38),
        prefixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 49, 102, 101),
        ),
      ),
    );
  }

  Future<void> addExpense() async {
    String checkerUserEmail = await UserModel.decideCheckerUserEmailByRole(
      LoginPage.currentUserEmail ?? "",
    );
    String status = await UserModel.decideStatusByRole(
      LoginPage.currentUserEmail ?? "",
    );

    ExpenseModel(
      title: titleController.text,
      status: status,
      price: priceController.text,
      date: dateController.text,
      description: descriptionController.text,
      userEmail: LoginPage.currentUserEmail ?? "",
      checkerUserEmail: checkerUserEmail,
      category: categoryController.text,
    ).createExpense();
  }

  List<WordBox> getText(RecognizedText recognisedText) {
    List<WordBox> wordBoxes = [];
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          // Access bounding box through parent elements (TextLine and TextBlock)
          Rect boundingBox = element.boundingBox;
          // You can now use the boundingBox Rect object as needed
          wordBoxes
              .add(WordBox(element.text, boundingBox, element.cornerPoints));
        }
      }
    }
    return wordBoxes;
  }

  List<Line> constructLineWithBoundingPolygon(List<WordBox> wordBoxes) {
    List<Line> lines = [];
    List<WordBox> currentLine = [];

    // Sözcük kutularını sıralayın (örneğin, sol üst köşe koordinatlarına göre)
    wordBoxes.sort(
        (a, b) => a.boundingBox.topLeft.dy.compareTo(b.boundingBox.topLeft.dy));

    for (int i = 0; i < wordBoxes.length; i++) {
      WordBox wordBox = wordBoxes[i];

      if (currentLine.isEmpty) {
        // İlk sözcüğü ekle ve geçerli satıra başla
        currentLine.add(wordBox);
      } else {
        // Eğer sözcüğün üst sol köşesi mevcut satırın üst kısmı ile aynıysa, mevcut satıra ekle
        if ((wordBox.boundingBox.top - currentLine.first.boundingBox.top)
                .abs() <=
            10) {
          currentLine.add(wordBox);
        } else {
          // Mevcut satırı tamamla ve yeni satıra başla
          lines.add(Line(List.from(currentLine)));
          currentLine.clear();
          currentLine.add(wordBox);
        }
      }
    }
    // Son satırı ekle
    if (currentLine.isNotEmpty) {
      lines.add(Line(List.from(currentLine)));
    }
    return lines;
  }

  List<Line> arrangeWordsInOrder(List<Line> lines) {
    // Satırları sözcük kutularına göre sıralama
    lines.forEach((line) {
      line.wordBoxes
          .sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
    });
    return lines;
  }

  void _readTextFromImage() async {
    // Seçilen resmi InputImage formatına dönüştür
    final inputImage = InputImage.fromFilePath(widget.imagePath);

    // Metin algılayıcıyı başlat
    final textDetector = TextRecognizer();

    // Resim üzerinde metin algılama işlemini gerçekleştir
    final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);

    // Metindeki kelimelerin kutularını al
    List<WordBox> wordBoxes = getText(recognizedText);

    // Kelimeleri sınırlayıcı çokgenle birleştirerek satırlar oluştur
    List<Line> lines = constructLineWithBoundingPolygon(wordBoxes);

    // Kelimeleri sıralayarak satırları düzenle
    lines = arrangeWordsInOrder(lines);

    String price = "";
    String date = "";
    //String title = "";

    for (Line line in lines) {
      // Satırdaki kelimeleri birleştirerek küçük harfe dönüştür ve boşluklarla birleştir
      String text =
          line.wordBoxes.map((e) => e.text).join(' ').toLowerCase().trim();
      print("Line text: $text"); // Satır metnini yazdır

      if (text.contains('toplam') || text.contains('total')) {
        // Toplam içeren satırları bulmak için regex deseni kullan
        RegExp amountPattern = RegExp(r'[\d,.]+');
        Match? match = amountPattern.firstMatch(text);
        if (match != null) {
          price = match.group(0)!;
          price = fixNumberFormat(price); // Toplamı biçimlendir
          print("Total: " + price); // Toplamı yazdır
        }
      } else if (text.contains('tarih') ||
          text.contains('date') ||
          text.contains('taríh')) {
        // Tarih içeren satırları bulmak için regex deseni kullan
        RegExp datePattern = RegExp(r'(\d{2}).(\d{2}).(\d{4})');
        Match? dateMatch = datePattern.firstMatch(text);
        print("---------DATE---------$dateMatch");
        if (dateMatch != null) {
          date =
              "${dateMatch.group(1)}/${dateMatch.group(2)}/${dateMatch.group(3)}"; // Tarihi biçimlendir
          print("Date: $date"); // Tarihi yazdır
        }
      }
    }

    // Durumu güncelle ve değerleri atanmış değişkenleri kullan

    //titleController.text = title;
    dateController.text = date;
    priceController.text = price;

    // Metin algılayıcıyı kapat
    textDetector.close();
  }

  String fixNumberFormat(String amount) {
    return amount.replaceAll(',', '.').replaceAll(RegExp(r'\s+'), '');
  }
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
