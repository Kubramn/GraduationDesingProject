import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeaderDashboard extends StatefulWidget {
  const LeaderDashboard({super.key});

  @override
  State<LeaderDashboard> createState() => _LeaderDashboardState();
}

class _LeaderDashboardState extends State<LeaderDashboard> {
  User? user = FirebaseAuth.instance.currentUser;
  String? _selectedTeam;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              highlightColor: Color.fromARGB(100, 227, 185, 117),
              icon: Icon(
                Icons.filter_alt,
                size: 35,
                color: Color.fromARGB(255, 96, 71, 36),
              ),
              onPressed: () {
                showFilterDialog(context, screenWidth, screenHeight);
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 229, 229, 225),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.005),
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
                //SizedBox(height: screenHeight * 0.005),
                Divider(
                  height: screenHeight * 0.04,
                  color: Color.fromARGB(255, 96, 71, 36),
                  thickness: 1.5,
                  indent: screenWidth * 0.01,
                  endIndent: screenWidth * 0.01,
                ),
                SizedBox(
                  height: screenHeight * 0.7,
                  child: TabBarView(
                    children: [
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
        return [];
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

  Future<dynamic> showFilterDialog(
      BuildContext context, double screenWidth, double screenHeight) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Color.fromARGB(255, 227, 185, 117),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        insetPadding: EdgeInsets.symmetric(
            //horizontal: screenWidth * 0.06,
            //vertical: screenHeight * 0.1,
            ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: Color.fromARGB(255, 227, 185, 117),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: Color.fromARGB(255, 96, 71, 36),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
        content: SizedBox(
          height: 600,
          width: 300,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              StreamBuilder<List<UserModel>>(
                stream: UserModel.fetchAllLeaders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final leaders = snapshot.data!;
                    return DropdownMenu<String>(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 52, 52, 52),
                      ),
                      width: screenWidth * 0.6,
                      leadingIcon: Icon(
                        Icons.person_search,
                        color: Color.fromARGB(255, 96, 71, 36),
                      ),
                      trailingIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color.fromARGB(255, 96, 71, 36),
                      ),
                      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                            color: Colors.black38, fontWeight: FontWeight.w500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 227, 185, 117),
                            width: 1.5,
                          ),
                        ),
                      ),
                      hintText: "Select a team...",
                      menuStyle: MenuStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        alignment: Alignment.bottomLeft,
                        surfaceTintColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      onSelected: (team) {
                        setState(() {
                          _selectedTeam = team;
                          print(_selectedTeam);
                        });
                        /*




                        İŞLEMLEEEEEERRRRRRR




           */
                      },
                      dropdownMenuEntries: leaders.map((UserModel leader) {
                        return DropdownMenuEntry<String>(
                          leadingIcon: Icon(
                            Icons.person_outline,
                            color: Color.fromARGB(255, 96, 71, 36),
                          ),
                          label: leader.teamName,
                          value: leader.email,
                          style: ButtonStyle(
                            overlayColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 227, 185, 117),
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 52, 52, 52),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("ERROR!"));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expenseTile(
      ExpenseModel expense, double screenHeight, double screenWidth) {
    return SizedBox(
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
                    surfaceTintColor: Colors.transparent,
                    //shadowColor: statusInfoAndColor(expense)[1],
                    shadowColor: Colors.black,
                    //elevation: 5,
                    backgroundColor: Color.lerp(
                      statusInfoAndColor(expense)[1],
                      Colors.white,
                      0.97,
                    ),
                    //backgroundColor: statusInfoAndColor(expense)[1],
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.22,
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
                                    color: statusInfoAndColor(expense)[1],
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
                                            text:
                                                statusInfoAndColor(expense)[0],
                                          ),
                                        ],
                                      ),
                                      style: TextStyle(
                                        color: statusInfoAndColor(expense)[1],
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
}
