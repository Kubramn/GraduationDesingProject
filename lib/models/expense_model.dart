import "package:cloud_firestore/cloud_firestore.dart";

class ExpenseModel {
  String id;
  String title;
  String status;
  String price;
  String date;
  String description;
  String userEmail;
  String checkerUserEmail;
  String category;

  ExpenseModel({
    this.id = "",
    required this.title,
    required this.status,
    required this.price,
    required this.date,
    required this.description,
    required this.userEmail,
    required this.checkerUserEmail,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "price": price,
        "date": date,
        "description": description,
        "userEmail": userEmail,
        "checkerUserEmail": checkerUserEmail,
        "category": category,
      };

  static ExpenseModel fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        price: json["price"],
        date: json["date"],
        description: json["description"],
        userEmail: json["userEmail"],
        checkerUserEmail: json["checkerUserEmail"],
        category: json["category"],
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
      checkerUserEmail: checkerUserEmail,
      category: category,
    );
    await newExpense.set(expense.toJson());
  }

  static Stream<List<ExpenseModel>> fetchOneMemberExpenses(
    String status,
    String? email,
  ) {
    if (status == "previous") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where(
            Filter.and(
              Filter("userEmail", isEqualTo: email),
              Filter.or(
                Filter("status", isEqualTo: "acceptedByLeaderAndFinance"),
                Filter("status", isEqualTo: "denied"),
              ),
            ),
          )
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromJson(doc.data()))
              .toList());
    } else if (status == "waiting") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where(Filter.and(
            Filter("userEmail", isEqualTo: email),
            Filter.or(
              Filter("status", isEqualTo: "waiting"),
              Filter("status", isEqualTo: "acceptedByLeader"),
            ),
          ))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromJson(doc.data()))
              .toList());
    } else {
      return const Stream<List<ExpenseModel>>.empty();
    }
  }

  static Stream<List<ExpenseModel>> fetchTeamExpenses(String? email) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where(
          Filter.or(
            Filter("checkerUserEmail", isEqualTo: email),
            Filter("userEmail", isEqualTo: email),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  static Stream<List<ExpenseModel>> fetchAllExpenses() {
    return FirebaseFirestore.instance.collection('expenses').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  static Stream<List<ExpenseModel>> fetchRequestsForLeader(String? email) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where(
          Filter.and(
            Filter("checkerUserEmail", isEqualTo: email),
            Filter("status", isEqualTo: "waiting"),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  static Stream<List<ExpenseModel>> fetchRequestsForFinance(String? email) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where("status", isEqualTo: "acceptedByLeader")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  static Future<void> updateRequestStatus(String id, String status) async {
    try {
      await FirebaseFirestore.instance.collection("expenses").doc(id).update({
        "status": status,
      });

      print("Request status updated successfully!");
    } catch (e) {
      print("Error updating request status: $e");
    }
  }
}
