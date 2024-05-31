import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
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
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.06),
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
                Divider(
                  height: screenHeight * 0.04,
                  color: Color.fromARGB(255, 76, 89, 23),
                  thickness: 1.5,
                  indent: screenWidth * 0.01,
                  endIndent: screenWidth * 0.01,
                ),
                SizedBox(
                  height: screenHeight * 0.75,
                  child: TabBarView(
                    children: [
                      StreamBuilder<List<ExpenseModel>>(
                        stream: ExpenseModel.fetchOneMemberExpenses(
                          "previous",
                          LoginPage.currentUserEmail,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 76, 89, 23),
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
                                  "There is no previous expense of yours right now.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 76, 89, 23),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final expenses = snapshot.data!;
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      expenseTile(
                                        expenses[index],
                                        true, // previous
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
                      StreamBuilder<List<ExpenseModel>>(
                        stream: ExpenseModel.fetchOneMemberExpenses(
                          "waiting",
                          LoginPage.currentUserEmail,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 76, 89, 23),
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
                                  "There is no expense of yours awaiting approval right now.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 76, 89, 23),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final expenses = snapshot.data!;
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      expenseTile(
                                        expenses[index],
                                        false, // waiting
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> statusInfoAndColor(ExpenseModel expense) {
    if (expense.status == "acceptedByLeaderAndFinance") {
      return [
        "This expense has been accepted.",
        Colors.lightGreen,
      ];
    } else if (expense.status == "denied") {
      return [
        "This expense has been denied.",
        Colors.red,
      ];
    } else {
      return [
        "",
        Color.fromARGB(255, 76, 89, 23),
      ];
    }
  }

  Widget infoValuePair(String info, String value, ExpenseModel expense) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$info:  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusInfoAndColor(expense)[1],
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
        maxLines: 3,
        minFontSize: 25,
        maxFontSize: 25,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color.fromARGB(255, 52, 52, 52),
          fontSize: 25,
        ),
      ),
    );
  }

  Widget expenseTile(
    ExpenseModel expense,
    bool previousOrWaiting,
    double screenHeight,
    double screenWidth,
  ) {
    return SizedBox(
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
            trailing: IconButton(
              icon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 76, 89, 23),
                size: 30,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 191, 203, 155),
              ),
              onPressed: () {
                showExpenseDialog(
                    screenWidth, previousOrWaiting, screenHeight, expense);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showExpenseDialog(double screenWidth, bool previousOrWaiting,
      double screenHeight, ExpenseModel expense) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Color.fromARGB(255, 191, 203, 155),
        shadowColor: Colors.black,
        backgroundColor: previousOrWaiting
            ? Color.lerp(
                statusInfoAndColor(expense)[1],
                Colors.white,
                0.96,
              )
            : Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical:
              previousOrWaiting ? screenHeight * 0.25 : screenHeight * 0.3,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: previousOrWaiting
                  ? statusInfoAndColor(expense)[1]
                  : Color.fromARGB(255, 191, 203, 155),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: statusInfoAndColor(expense)[1],
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: previousOrWaiting,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: statusInfoAndColor(expense)[1],
                        size: 30,
                      ),
                      SizedBox(
                        width: screenWidth * 0.015,
                      ),
                      Text(
                        statusInfoAndColor(expense)[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: statusInfoAndColor(expense)[1],
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: previousOrWaiting,
                  child: Divider(
                    color: Color.fromARGB(255, 52, 52, 52),
                    thickness: 1.5,
                  ),
                ),
                Image.network(expense.image,width: 200,height: 200,),
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
      ),
    );
  }
}
