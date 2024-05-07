import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MemberExpenses extends StatelessWidget {
  const MemberExpenses({super.key});

  Stream<List<ExpenseModel>> fetchExpenses(String status) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where("status", isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  void addExpense() {
    ExpenseModel(
      title: "Kulaklık",
      status: "waiting",
      price: 80,
      date: DateTime.now(),
      description: "Ayşe Hanım müziksiz odaklanamıyormuş.",
    ).createExpense();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                TabBar(
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  //splashFactory: NoSplash.splashFactory,

                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tabs: [
                    Tab(
                      text: "Previous",
                    ),
                    Tab(
                      text: "Waiting",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    StreamBuilder<List<ExpenseModel>>(
                      stream: fetchExpenses("previous"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final expenses = snapshot.data!;
                          return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return expenseTile(expenses[index]);
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text('NO DATA!'));
                        } else {
                          return Center(child: Text('NO DATA!'));
                        }
                      },
                    ),
                    StreamBuilder<List<ExpenseModel>>(
                      stream: fetchExpenses("waiting"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final expenses = snapshot.data!;
                          return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return expenseTile(expenses[index]);
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text('NO DATA!'));
                        } else {
                          return Center(child: Text('NO DATA!'));
                        }
                      },
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () => addExpense(),
                  child: Text("ADD EXPENSE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget expenseTile(ExpenseModel expense) => Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          textColor: Colors.white,
          leading: Icon(
            Icons.attach_money,
            color: Colors.lightGreen,
            size: 30,
          ),
          title: Text(expense.title),
          subtitle: Text(expense.description),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      );
}
