import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
                SizedBox(height: screenHeight * 0.08),
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
                      text: LocaleData.previousTab.getString(context),
                    ),
                    Tab(
                      text: LocaleData.waitingTab.getString(context),
                    ),
                  ],
                ),
                Divider(
                  height: 40,
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
                              child: Text(LocaleData.error.getString(context)),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: SizedBox(
                                width: screenWidth * 0.8,
                                child: Text(
                                  LocaleData.errorNoPreviousExpense
                                      .getString(context),
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
                                      SizedBox(height: 10),
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
                              child: Text(LocaleData.error.getString(context)),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: SizedBox(
                                width: screenWidth * 0.8,
                                child: Text(
                                  LocaleData.errorNoWaitingExpense
                                      .getString(context),
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
                                      SizedBox(height: 10),
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
    switch (expense.status) {
      case "waiting":
        return [
          LocaleData.statusWaiting.getString(context),
          Colors.lightBlue,
        ];

      case "acceptedByLeader":
        return [
          LocaleData.statusAcceptedByLeader.getString(context),
          Colors.teal,
        ];

      case "acceptedByLeaderAndFinance":
        return [
          LocaleData.statusAcceptedByLeaderAndFinance.getString(context),
          Colors.lightGreen,
        ];

      case "denied":
        return [
          LocaleData.statusDenied.getString(context),
          Colors.red,
        ];

      default:
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
      height: 80,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black,
        color: Color.lerp(
          statusInfoAndColor(expense)[1],
          Colors.white,
          0.93,
        ),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: ListTile(
            textColor: Color.fromARGB(255, 52, 52, 52),
            leading: Icon(
              Icons.attach_money,
              color: statusInfoAndColor(expense)[1],
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
                Icons.menu,
                color: Color.lerp(
                  statusInfoAndColor(expense)[1],
                  Colors.white,
                  0.93,
                ),
                size: 30,
              ),
              style: IconButton.styleFrom(
                backgroundColor: statusInfoAndColor(expense)[1],
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
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        backgroundColor: Color.lerp(
          statusInfoAndColor(expense)[1],
          Colors.white,
          0.93,
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: previousOrWaiting ? 70 : 50,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: statusInfoAndColor(expense)[1],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              LocaleData.dialogCloseButton.getString(context),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: statusInfoAndColor(expense)[1],
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 20,
                      minFontSize: 20,
                      statusInfoAndColor(expense)[0],
                      style: TextStyle(
                        color: statusInfoAndColor(expense)[1],
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: statusInfoAndColor(expense)[1],
                thickness: 1.5,
              ),
              SizedBox(height: 5),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 350),
                child: Image.network(
                  expense.image,
                ),
              ),
              SizedBox(height: 10),
              infoValuePair(
                LocaleData.dialogTitle.getString(context),
                expense.title,
                expense,
              ),
              SizedBox(height: 2),
              infoValuePair(
                LocaleData.dialogDescription.getString(context),
                expense.description,
                expense,
              ),
              SizedBox(height: 2),
              infoValuePair(
                LocaleData.dialogDate.getString(context),
                expense.date,
                expense,
              ),
              SizedBox(height: 2),
              infoValuePair(
                LocaleData.dialogPrice.getString(context),
                expense.price,
                expense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
