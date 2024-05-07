import "package:cloud_firestore/cloud_firestore.dart";

class ExpenseModel {
  String id;
  String title;
  String status;
  int price;
  DateTime date;
  String description;

  ExpenseModel({
    this.id = "",
    required this.title,
    required this.status,
    required this.price,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "price": price,
        "date": date,
        "description": description,
      };

  static ExpenseModel fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        price: json["price"],
        date: (json["date"] as Timestamp).toDate(),
        description: json["description"],
      );

  Future createExpense() async {
    final newExpense = FirebaseFirestore.instance.collection('expenses').doc();
    final expense = ExpenseModel(
      id: newExpense.id,
      title: title,
      status: status,
      price: price,
      date: date,
      description: description,
    );
    await newExpense.set(expense.toJson());
  }
}
