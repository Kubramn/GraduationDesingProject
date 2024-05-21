import 'dart:io';

import 'package:flutter/material.dart';

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
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              Image.file(
                File(widget.imagePath),
              ),
              SizedBox(height: screenHeight * 0.06),
              InvoiceDetail(controller: title, hint: "Title"),
              SizedBox(height: screenHeight * 0.02),
              InvoiceDetail(controller: description, hint: "Description"),
              SizedBox(height: screenHeight * 0.02),
              InvoiceDetail(controller: date, hint: "Date"),
              SizedBox(height: screenHeight * 0.02),
              InvoiceDetail(controller: price, hint: "Price"),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: (() {}),
                child: Text(
                  "Add Expense",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Color.fromARGB(255, 67, 143, 174),
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
}

class InvoiceDetail extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const InvoiceDetail({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
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
          Icons.title,
          color: Color.fromARGB(255, 67, 179, 207),
        ),
      ),
    );
  }
}
