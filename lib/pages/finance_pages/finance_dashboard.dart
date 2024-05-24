import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  User? user = FirebaseAuth.instance.currentUser;

  List<dynamic> statusInfo(ExpenseModel expense) {
    switch (expense.status) {
      case "waiting":
        return [
          " and is currently awaiting approval.",
          Colors.lightBlue,
        ];

      case "acceptedByLeader":
        return [
          " and has been accepted by you but is currently awaiting approval from Finance.",
          Colors.teal,
        ];

      case "acceptedByLeaderAndFinance":
        return [
          " and has been accepted.",
          Colors.lightGreen,
        ];

      case "denied":
        return [
          " and has been denied.",
          Colors.red,
        ];

      default:
        return [null];
    }
  }

  Align infoValuePair(
    String info,
    String value,
    ExpenseModel expense,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$info:  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusInfo(expense)[1],
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
        maxLines: 3,
        minFontSize: 30,
        maxFontSize: 30,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color.fromARGB(255, 52, 52, 52),
          fontSize: 30,
        ),
      ),
    );
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
                  labelColor: Color.fromARGB(255, 96, 71, 36),
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Color.fromARGB(150, 96, 71, 36),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  splashBorderRadius: BorderRadius.circular(15),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return states.contains(WidgetState.focused)
                          ? null
                          : Color.fromARGB(50, 227, 185, 117);
                    },
                  ),
                  indicator: BoxDecoration(
                    color: Color.fromARGB(170, 227, 185, 117),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tabs: [
                    Tab(
                      text: "Graphic",
                    ),
                    Tab(
                      text: "List",
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.028),
                Divider(
                  height: screenHeight * 0.01,
                  color: Color.fromARGB(255, 96, 71, 36),
                  thickness: 1.5,
                  indent: screenWidth * 0.01,
                  endIndent: screenWidth * 0.01,
                ),
                SizedBox(
                  height: screenHeight * 0.71,
                  child: TabBarView(children: [
                    Center(child: Text("data")),
                    StreamBuilder<List<ExpenseModel>>(
                      stream: ExpenseModel.fetchTeamExpenses(user?.email),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 96, 71, 36),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('ERROR!'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              child: Text(
                                "There is no expense from your team right now.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 96, 71, 36),
                                ),
                              ),
                            ),
                          );
                        } else {
                          final expenses = snapshot.data!;
                          return ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    expenseTile(
                                      expenses[index],
                                      screenHeight,
                                      screenWidth,
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ]),
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
          shadowColor: Color.fromARGB(255, 227, 185, 117),
          color: Colors.white,
          surfaceTintColor: Color.fromARGB(255, 227, 185, 117),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: ListTile(
              textColor: Color.fromARGB(255, 52, 52, 52),
              leading: Icon(
                Icons.attach_money,
                color: Color.fromARGB(255, 96, 71, 36),
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
                  color: Color.fromARGB(255, 96, 71, 36),
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 227, 185, 117),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      surfaceTintColor: Color.fromARGB(255, 227, 185, 117),
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
                              color: statusInfo(expense)[1],
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                      content: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FutureBuilder<String>(
                              future: UserModel.getNameSurnameByEmail(
                                  expense.userEmail),
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: statusInfo(expense)[1],
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.035,
                                    ),
                                    Expanded(
                                      child: AutoSizeText.rich(
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        maxFontSize: 20,
                                        minFontSize: 20,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "This expense was incurred by ",
                                            ),
                                            TextSpan(
                                              text: snapshot.data,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: statusInfo(expense)[0],
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(
                                          color: statusInfo(expense)[1],
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Divider(
                              color: Color.fromARGB(255, 52, 52, 52),
                              thickness: 1.5,
                            ),
                            infoValuePair(
                              "Title",
                              expense.title,
                              expense,
                            ),
                            infoValuePair(
                              "Description",
                              expense.description,
                              expense,
                            ),
                            infoValuePair(
                              "Date",
                              expense.date,
                              expense,
                            ),
                            infoValuePair(
                              "Price",
                              expense.price,
                              expense,
                            ),
                          ],
                        ),
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
