import "package:cloud_firestore/cloud_firestore.dart";

class ExpenseModel {
  String id;
  String title;
  String status;
  String price;
  DateTime date;
  String description;
  String userEmail;
  String teamName;

  ExpenseModel({
    this.id = "",
    required this.title,
    required this.status,
    required this.price,
    required this.date,
    required this.description,
    required this.userEmail,
    required this.teamName,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "price": price,
        "date": date,
        "description": description,
        "userEmail": userEmail,
        "teamName": teamName,
      };

  static ExpenseModel fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        price: json["price"],
        date: (json["date"] as Timestamp).toDate(),
        description: json["description"],
        userEmail: json["userEmail"],
        teamName: json["teamName"],
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
      userEmail: userEmail,
      teamName: teamName,
    );
    await newExpense.set(expense.toJson());
  }
}
