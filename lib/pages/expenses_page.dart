import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<ExpenseModel>> fetchExpenses(String status) {
    if (status == "previous") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where(
            Filter.and(
              Filter("userEmail", isEqualTo: user?.email),
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
            Filter("userEmail", isEqualTo: user?.email),
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

  void addExpense() {
    ExpenseModel(
      title: "Long Description",
      status: "accepted",
      price: "100₺",
      date: DateTime.now(),
      description: "description description description",
      userEmail: "new@gmail.com",
      checkerUserEmail: "leader@gmail.com",
      teamName: "team1",
    ).createExpense();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);

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
                  unselectedLabelColor: Color.fromARGB(150, 76, 89, 23),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(15),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return states.contains(WidgetState.focused)
                          ? null
                          : Color.fromARGB(50, 191, 203, 155);
                    },
                  ),
                  indicator: BoxDecoration(
                    color: Color.fromARGB(170, 191, 203, 155),
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
                SizedBox(
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
    ExpenseModel expense,
    double screenHeight,
    double screenWidth,
  ) =>
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
                size: 34,
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
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.20,
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
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InfoValue(
                            info: "Title:  ",
                            value: expense.title,
                          ),
                          InfoValue(
                            info: "Description:  ",
                            value: expense.description,
                          ),
                          InfoValue(
                            info: "Date:  ",
                            value:
                                DateFormat('MMMM d, yyyy').format(expense.date),
                          ),
                          InfoValue(
                            info: "Price:  ",
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

class InfoValue extends StatelessWidget {
  final String info;
  final String value;

  const InfoValue({
    super.key,
    required this.info,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          info,
          style: TextStyle(
            color: Color.fromARGB(255, 52, 52, 52),
            fontSize: 30,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            value,
            maxLines: 3,
            minFontSize: 25,
            maxFontSize: 30,
            style: TextStyle(
              color: Color.fromARGB(255, 52, 52, 52),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
