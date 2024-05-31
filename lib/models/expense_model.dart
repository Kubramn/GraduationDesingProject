import 'dart:math';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:collection/collection.dart';
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

  static Future<List<Data>> getData() async {
    List<Data> list = [];
    List<ExpenseModel> data = await fetchAllExpenses().first;
    for (var element in data) {
      String email = element.userEmail;
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("users").doc(email).get();
      Map<String, dynamic> doc = ds.data() as Map<String, dynamic>;
      String department = doc["department"];
      String teamName = doc["teamName"];
      List<String> ts = element.date.split("/");
      DateTime date = DateTime(int.parse(ts[2]),int.parse(ts[1]),int.parse(ts[0]));
      double price = double.parse(element.price);
      String category = element.category;
      if (date.isAfter(DateTime(1700)) && date.isBefore(DateTime(2100))) {
        list.add(Data(date, price, category,teamName,department));
      }
    }
    return list;
  }

  static Future<List<Data>> sortTime(DateTime? startDate,DateTime? endDate) async {
    List<Data> a = await getData();
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
      }
    }

    data.sort((a, b) => a.time.compareTo(b.time));
    var groupedData = groupBy<Data, DateTime>(
      data,
          (data) => data.dateOnly,
    );
    var summedData = groupedData.entries.map((entry) {
      var firstEntry = entry.value.first;
      var totalSum = entry.value.fold<num>(0, (sum, data) => sum + data.price);
      return Data(firstEntry.dateOnly, totalSum, 'Total',"s","s");
    }).toList();
    return summedData;
  }


  static Future<List<Data>> categorySum(DateTime? startDate,DateTime? endDate) async {
    List<Data> a = await getData();
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
      }
    }

    Map<String, num> totalPrices = {};
    for (var data in data) {
      if (totalPrices.containsKey(data.category)) {
        totalPrices[data.category] = (totalPrices[data.category]! + data.price);
      } else {
        totalPrices[data.category] = data.price;
      }
    }
    List<Data> result = totalPrices.entries.map((e) => Data(DateTime(0), e.value, e.key,"s","s")).toList();
    return result;
  }
  static Future<List<Data>> departmentSum(DateTime? startDate,DateTime? endDate) async {
    List<Data> a = await getData();
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
      }
    }

    Map<String, num> totalPrices = {};
    for (var data in data) {
      if (totalPrices.containsKey(data.department)) {
        totalPrices[data.department] = (totalPrices[data.department]! + data.price);
      } else {
        totalPrices[data.department] = data.price;
      }
    }
    List<Data> result = totalPrices.entries.map((e) => Data(DateTime(0),  e.value,"s","s", e.key)).toList();
    return result;
  }

  static List<List<Data>> regression(List<Data> list){
    int tx=0,tx2=0;
    double ty=0,txy=0;
    int n= list.length;
    int ft= (list.first.time.millisecondsSinceEpoch/86400000).floor();
    int lt= (list.last.time.millisecondsSinceEpoch/86400000).floor();
    for (var data in list){
      tx = tx + (data.time.millisecondsSinceEpoch/86400000).floor()-ft;
      ty = ty + (data.price as double);
      txy = txy + (((data.time.millisecondsSinceEpoch/86400000).floor()-ft)*(data.price as double));
      tx2 = tx2 +pow(((data.time.millisecondsSinceEpoch/86400000).floor()-ft), 2).floor();
    }
    double a = (((ty * tx2) - (tx * txy)) / ((n * tx2) - pow(tx, 2)));
    double b = (((n * txy) - (tx * ty)) / ((n * tx2) - pow(tx, 2)));
    List<Data> est=[];
    for(var data in list){
      double t= (data.time.millisecondsSinceEpoch/86400000)-ft;
      num price= a+(t*b);

      Data x= Data(DateTime.fromMillisecondsSinceEpoch((t+ft).floor()*86400000), price, "s","s","s");
      est.add(x);
    }
    List<double> x=[];
    for(int i=0;i<est.length;i++){
      x.add((list[i].price-est[i].price) as double);
    }
    x.sort((a,b)=> a.compareTo(b));
    List<Data> upper=[];
    int t= lt-ft;
    for(int i=0;i<(t*4/3).floor();i++){

      DateTime date= DateTime.fromMillisecondsSinceEpoch((i+ft)*86400000);
      upper.add(Data(date, a+(i*b)+(x[(9*x.length/10).floor()]), "category", "teamName", "department"));
    }
    List<Data> lower=[];
    for(int i=0;i<(t*4/3).floor();i++){

      DateTime date= DateTime.fromMillisecondsSinceEpoch((i+ft)*86400000);
      lower.add(Data(date, a+(i*b)+(x[(x.length/10).floor()]), "category", "teamName", "department"));
    }
    return [lower,upper,est];
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