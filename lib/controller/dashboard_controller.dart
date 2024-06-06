import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';
import 'package:collection/collection.dart';
class dashboardController{
  static List<ExpenseModel> dateSort(List<ExpenseModel> expenses,DateTime? filterStartDate, DateTime? filterEndDate){
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
  static Future<List<Data>> getFinanceData() async {
    List<Data> list = [];
    List<ExpenseModel> data = await ExpenseModel.fetchAllExpenses(null,null).first;
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
      list.add(Data(date, price, category,teamName,department));
    }
    print(list.length);
    return list;
  }

  static Future<List<Data>> getLeaderData(String? email) async {
    List<Data> list = [];
    List<ExpenseModel> data = await ExpenseModel.fetchTeamExpenses(email,null).first;
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
      list.add(Data(date, price, category,teamName,department));
    }
    print(list.length);
    return list;
  }


  static Future<List<Data>> sortTime(Future<List<Data>> list,DateTime? startDate,DateTime? endDate,String? teamName, String? category) async {
    List<Data> a = await list;
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        if(teamName!=""&& category!=null){
          if(x.teamName==teamName&&x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName==""&& category!=null){
          if(x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName!=""&& category==null){
          if(x.teamName==teamName){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else{
          data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
        }
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


  static Future<List<Data>> categorySum(Future<List<Data>> list,DateTime? startDate,DateTime? endDate,String? teamName, String? category) async {
    List<Data> a = await list;
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        if(teamName!=""&& category!=null){
          if(x.teamName==teamName&&x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName==""&& category!=null){
          if(x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName!=""&& category==null){
          if(x.teamName==teamName){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else{
          data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
        }
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
  static Future<List<Data>> departmentSum(Future<List<Data>> list,DateTime? startDate,DateTime? endDate,String? teamName, String? category) async {
    List<Data> a = await list;
    List<Data> data=[];
    for(var x in a){
      if (x.time.isAfter(startDate!) && x.time.isBefore(endDate!)) {
        if(teamName!=""&& category!=null){
          if(x.teamName==teamName&&x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName==""&& category!=null){
          if(x.category==category){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else if(teamName!=""&& category==null){
          if(x.teamName==teamName){
            data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
          }
        }else{
          data.add(Data(x.time, x.price, x.category,x.teamName,x.department));
        }
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