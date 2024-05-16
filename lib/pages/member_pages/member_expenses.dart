import 'package:bitirme/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberExpenses extends StatefulWidget {
  const MemberExpenses({super.key});

  @override
  State<MemberExpenses> createState() => _MemberExpensesState();
}

class _MemberExpensesState extends State<MemberExpenses> {
  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<ExpenseModel>> fetchExpenses(String status) {
    if (status == "previous") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where(
            Filter.and(
              Filter("userEmail", isEqualTo: user?.email),
              Filter.or(
                Filter("status", isEqualTo: "accepted"),
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
            Filter("userEmail", isEqualTo: user?.email),
            Filter("status", isEqualTo: "waiting"),
          ))
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromJson(doc.data()))
              .toList());
    } else {
      return const Stream<List<ExpenseModel>>.empty();
    }
  }

  void addExpense() {
    ExpenseModel(
      title: "Long Description",
      status: "accepted",
      price: "100₺",
      date: DateTime.now(),
      description: "description description description",
      userEmail: "new@gmail.com",
      teamName: "team1",
    ).createExpense();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 229, 225),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.04),
                TabBar(
                  labelColor: Color.fromARGB(255, 76, 89, 23),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(15),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return states.contains(WidgetState.focused)
                          ? null
                          : Colors.white38;
                    },
                  ),
                  indicator: BoxDecoration(
                    color: Colors.white70,
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
                SizedBox(height: screenHeight * 0.028),
                Divider(
                  height: screenHeight * 0.01,
                  color: Color.fromARGB(255, 76, 89, 23),
                  thickness: 1.5,
                  indent: screenWidth * 0.01,
                  endIndent: screenWidth * 0.01,
                ),
                Container(
                  //color: Colors.black,
                  height: screenHeight * 0.65,
                  child: TabBarView(children: [
                    StreamBuilder<List<ExpenseModel>>(
                      stream: fetchExpenses("previous"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final expenses = snapshot.data!;
                          return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    expenseTile(expenses[index], screenHeight,
                                        screenWidth),
                                    SizedBox(height: screenHeight * 0.01),
                                  ],
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text('NO DATA!'));
                        } else {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
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
                                return expenseTile(
                                    expenses[index], screenHeight, screenWidth);
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text('NO DATA!'));
                        } else {
                          return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          );
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

  Widget expenseTile(
          ExpenseModel expense, double screenHeight, double screenWidth) =>
      SizedBox(
        height: screenHeight * 0.08,
        child: Card(
          elevation: 3,
          shadowColor: Color.fromARGB(255, 191, 203, 155),
          color: Colors.white,
          surfaceTintColor: Color.fromARGB(255, 191, 203, 155),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: ListTile(
              textColor: Color.fromARGB(255, 52, 52, 52),
              leading: Icon(
                Icons.attach_money,
                color: Color.fromARGB(255, 76, 89, 23),
                size: 32,
              ),
              title: Text(
                expense.title,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              //subtitle: Text(expense.description),
              trailing: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 76, 89, 23),
                  size: 30,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 191, 203, 155)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      surfaceTintColor: Color.fromARGB(255, 76, 89, 23),
                      backgroundColor: Colors.white,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.0, //0.06
                        vertical: screenHeight * 0.0, //0.25
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(
                                color: Color.fromARGB(255, 76, 89, 23),
                                fontSize: 20),
                          ),
                        )
                      ],
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Attribute(
                            attribute: "Title:  ",
                            value: expense.title,
                          ),
                          Attribute(
                            attribute: "Description:  ",
                            value: expense.description,
                          ),
                          Attribute(
                            attribute: "Date:  ",
                            value:
                                DateFormat('MMMM d, yyyy').format(expense.date),
                          ),
                          Attribute(
                            attribute: "Price:  ",
                            value: expense.price,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class Attribute extends StatelessWidget {
  final String attribute;
  final String value;

  const Attribute({
    super.key,
    required this.attribute,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        children: [
          Text(
            attribute,
            style: TextStyle(
              color: Color.fromARGB(255, 52, 52, 52),
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            overflow: TextOverflow.clip,
            value,
            style: TextStyle(
              color: Color.fromARGB(255, 52, 52, 52),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
