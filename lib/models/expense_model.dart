import 'dart:io';
import 'dart:math';

import "package:cloud_firestore/cloud_firestore.dart";

import "package:firebase_storage/firebase_storage.dart";
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
  String image;

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
    required this.image,
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
    "image":image,
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
    image: json["image"],
  );

  Future createExpense() async {
    final newExpense = FirebaseFirestore.instance.collection('expenses').doc();
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
    UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(File(image));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
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
      image: downloadUrl,
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

  static Stream<List<ExpenseModel>> fetchTeamExpenses(String? email, String? category) {
    Filter filt=Filter.and(
      Filter.or(
        Filter("checkerUserEmail", isEqualTo: email),
        Filter("userEmail", isEqualTo: email),
      ),
      Filter.or(
        Filter("status",isEqualTo: "acceptedByLeader"),
        Filter("status",isEqualTo: "acceptedByLeaderAndFinance"),
      ),
    );
    if(category!=null){
      filt=Filter.and(filt,Filter("category",isEqualTo: category));
    }
    return FirebaseFirestore.instance
        .collection('expenses')
        .where(
        filt
    )
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()))
        .toList());
  }

  static Stream<List<ExpenseModel>> fetchAllExpenses(String? mail, String? category) {
    Filter filt=Filter.or(
        Filter("status", isEqualTo: "acceptedByLeaderAndFinance"),
        Filter("status", isEqualTo: "acceptedByLeader")
    );
    if(category!=null){
      filt=Filter.and(filt,Filter("category",isEqualTo: category));
    }
    if(mail!=null){
      filt=Filter.and(filt,Filter("checkerUserEmail",isEqualTo: mail));
    }
    return FirebaseFirestore.instance.collection('expenses')
        .where(
        filt
    )
        .snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  static List<ExpenseModel> dateFilter(List<ExpenseModel> expenses,DateTime? filterStartDate, DateTime? filterEndDate){
    List<ExpenseModel> list=[];
    for (var data in expenses){
      List<String> ts = data.date.split("/");
      DateTime date = DateTime(int.parse(ts[2]),int.parse(ts[1]),int.parse(ts[0]));
      if (date.isAfter(filterStartDate!) && date.isBefore(filterEndDate!)) {
        list.add(data);
      }
    }
    return list;
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
class Data {
  Data(this.time, this.price, this.category, this.teamName, this.department);
  final DateTime time;
  final num price;
  final String category;
  final String teamName;
  final String department;

  DateTime get dateOnly => DateTime(time.year, time.month, time.day);

  String get compare => "$time $category $teamName";

  DateTime getDate() {
    return DateTime(time.year, time.month, time.day);
  }

  @override
  String toString() {
    return "category: $category price: $price time: ${getDate()}";
  }
}