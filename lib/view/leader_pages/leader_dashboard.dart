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
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  TextEditingController teamController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

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
                                padding: EdgeInsets.zero,
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
          horizontal: 5,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 227, 185, 117),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Apply",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 227, 185, 117),
                ),
                onPressed: () {
                  teamController.clear();
                  categoryController.clear();
                  filterStartDate = DateTime(2000);
                  filterEndDate = DateTime.now();
                },
                child: Text(
                  "Reset",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              ),
            ],
          )
        ],
        content: SizedBox(
          height: 280,
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              teamDropdownMenu(screenWidth),
              SizedBox(height: 40),
              categoryDropdownMenu(),
              SizedBox(height: 40),
              dateRangeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<UserModel>> teamDropdownMenu(double screenWidth) {
    return StreamBuilder<List<UserModel>>(
      stream: UserModel.fetchAllLeaders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final leaders = snapshot.data!;
          return DropdownMenu<String>(
            controller: teamController,
            width: 340,
            leadingIcon: Icon(
              Icons.groups,
              color: Color.fromARGB(255, 96, 71, 36),
            ),
            trailingIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromARGB(255, 96, 71, 36),
            ),
            selectedTrailingIcon: Icon(
              Icons.keyboard_arrow_up,
              color: Color.fromARGB(255, 96, 71, 36),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
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
              surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            onSelected: (_) {
              setState(() {});
              /*




                      İŞLEMLEEEEEERRRRRRR




         */
            },
            dropdownMenuEntries: leaders.map((UserModel leader) {
              return DropdownMenuEntry<String>(
                leadingIcon: Icon(
                  Icons.groups_outlined,
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
    );
  }

  Widget categoryDropdownMenu() {
    return DropdownMenu<String>(
      controller: categoryController,
      width: 340,
      leadingIcon: Icon(
        Icons.category,
        color: Color.fromARGB(255, 96, 71, 36),
      ),
      trailingIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Color.fromARGB(255, 96, 71, 36),
      ),
      selectedTrailingIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Color.fromARGB(255, 96, 71, 36),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle:
            TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 227, 185, 117),
            width: 1.5,
          ),
        ),
      ),
      hintText: "Select a category...",
      menuStyle: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        alignment: Alignment.bottomLeft,
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onSelected: (_) {
        setState(() {});
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: "Travel and Transportation",
          label: "Travel and Transportation",
          leadingIcon: Icon(
            Icons.emoji_transportation,
            color: Color.fromARGB(255, 96, 71, 36),
          ),
        ),
        DropdownMenuEntry(
          value: "Meals and Entertainment",
          label: "Meals and Entertainment",
          leadingIcon: Icon(
            Icons.fastfood_outlined,
            color: Color.fromARGB(255, 96, 71, 36),
          ),
        ),
        DropdownMenuEntry(
          value: "Office Supplies and Equipment",
          label: "Office Supplies and Equipment",
          leadingIcon: Icon(
            Icons.meeting_room_outlined,
            color: Color.fromARGB(255, 96, 71, 36),
          ),
        ),
        DropdownMenuEntry(
          value: "Other Expenses",
          label: "Other Expenses",
          leadingIcon: Icon(
            Icons.attach_money,
            color: Color.fromARGB(255, 96, 71, 36),
          ),
        ),
      ],
    );
  }

  Widget dateRangeButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 340,
      child: ElevatedButton(
        onPressed: (() async {
          final dateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );

          if (dateRange != null) {
            setState(() {
              filterStartDate = dateRange.start;
              filterEndDate = dateRange.end;
            });
          }
        }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range,
              color: Color.fromARGB(255, 96, 71, 36),
            ),
            SizedBox(width: 10),
            Text(
              "Select Date Range",
              style: TextStyle(
                color: Color.fromARGB(255, 96, 71, 36),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          overlayColor: Color.fromARGB(255, 227, 185, 117),
          backgroundColor: Colors.white,
          //foregroundColor: Color.fromARGB(255, 52, 52, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Color.fromARGB(255, 227, 185, 117),
              width: 1.5,
            ),
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
                showExpenseDialog(expense, screenWidth, screenHeight);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showExpenseDialog(
      ExpenseModel expense, double screenWidth, double screenHeight) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        backgroundColor: Color.lerp(
          statusInfoAndColor(expense)[1],
          Colors.white,
          0.96,
        ),
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
                future: UserModel.getNameSurnameByEmail(expense.userEmail),
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
                                text: "This expense was incurred by ",
                              ),
                              TextSpan(
                                text: snapshot.data,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: statusInfoAndColor(expense)[0],
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
  }
}
