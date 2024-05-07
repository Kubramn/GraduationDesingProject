import "dart:ui";
import "package:cloud_firestore/cloud_firestore.dart";

class Request{
  final CollectionReference requestCollection = FirebaseFirestore.instance.collection("request");
  String requestID,category,description,title,employeeUsername;
  double price;
  Image? invoice;
  DateTime? date;
  Request( this.requestID, this.category, this.description, this.title, this.price, this.employeeUsername, this.invoice, this.date){
    requestCollection.doc(requestID).set({
      "requestID":requestID,
      "category":category,
      "invoice":invoice,
      "date":date,
      "description":description,
      "title":title,
      "price":price,
      "employeeUsername":employeeUsername
    });
  }
}