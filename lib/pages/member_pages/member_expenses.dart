import 'package:bitirme/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberExpenses extends StatefulWidget {
  const MemberExpenses({super.key});

  @override
  State<MemberExpenses> createState() => _MemberExpensesState();
}

class _MemberExpensesState extends State<MemberExpenses> {
  Stream<List<ExpenseModel>> fetchExpenses(String status) {
    if (status == "previous") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where(
            Filter.or(
              Filter("status", isEqualTo: "accepted"),
              Filter("status", isEqualTo: "denied"),
            ),
          )
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromJson(doc.data()))
              .toList());
    } else if (status == "waiting") {
      return FirebaseFirestore.instance
          .collection('expenses')
          .where("status", isEqualTo: "waiting")
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
      title: "Kulaklık",
      status: "accepted",
      price: 100,
      date: DateTime.now(),
      description: "description description description",
      userEmail: "atakan@gmail.com",
      teamName: "team1",
    ).createExpense();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 90, 175),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
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
                splashBorderRadius: BorderRadius.circular(15),
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return states.contains(MaterialState.focused)
                        ? null
                        : Colors.black12;
                  },
                ),
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
              SizedBox(height: 25),
              Divider(
                height: 20,
                color: Colors.white,
                thickness: 1.5,
                indent: 5,
                endIndent: 5,
              ),
              Container(
                height: 600,
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
                                  expenseTile(expenses[index]),
                                  SizedBox(height: 10),
                                ],
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(child: Text('NO DATA!'));
                      } else {
                        return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white));
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
    );
  }

  Widget expenseTile(ExpenseModel expense) => SizedBox(
        height: 80,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: ListTile(
              textColor: Colors.white,
              leading: Icon(
                Icons.attach_money,
                color: Colors.lightGreen,
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
                  color: Colors.white,
                  size: 30,
                ),
                style: IconButton.styleFrom(backgroundColor: Colors.white38),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      insetPadding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 310),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        )
                      ],
                      content: Column(
                        children: [
                          Attribute(
                            attribute: "Title: ",
                            value: expense.title,
                          ),
                          const SizedBox(height: 10),
                          Attribute(
                            attribute: "Description: ",
                            value: expense.description,
                          ),
                          const SizedBox(height: 10),
                          Attribute(
                            attribute: "Date: ",
                            value:
                                DateFormat('MMMM d, yyyy').format(expense.date),
                          ),
                          const SizedBox(height: 10),
                          Attribute(
                            attribute: "Price: ",
                            value: expense.price.toString(),
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
    return Row(
      children: [
        Text(
          attribute,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        )
      ],
    );
  }
}
