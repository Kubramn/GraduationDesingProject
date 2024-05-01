import "dart:ui";
import "package:cloud_firestore/cloud_firestore.dart";

class Expense{
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection("expense");
  String expenseID,category,description,title,teamid;
  double price;
  Image? invoice;
  DateTime? date;
  Expense( this.expenseID, this.category, this.description, this.title, this.price, this.teamid, this.invoice, this.date){
    expenseCollection.doc(expenseID).set({
      "requestID":expenseID,
      "category":category,
      "invoice":invoice,
      "date":date,
      "description":description,
      "title":title,
      "price":price,
      "teamID":teamid
    });
  }
}