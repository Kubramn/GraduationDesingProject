import 'package:flutter/material.dart';

void alertMessage(String message, Color backgroundColor, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shadowColor: Colors.black,
        surfaceTintColor: backgroundColor,
        backgroundColor: Colors.white,
        title: Text(
          message,
          style: TextStyle(
            color: Color.fromARGB(255, 52, 52, 52),
            fontSize: 25,
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(
                backgroundColor,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: Color.fromARGB(255, 52, 52, 52),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    },
  );
}
