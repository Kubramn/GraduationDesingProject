import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/team_model.dart';

class LeaderDashboard extends StatefulWidget {
  const LeaderDashboard({super.key});

  @override
  State<LeaderDashboard> createState() => _LeaderDashboardState();
}

class _LeaderDashboardState extends State<LeaderDashboard> {
  DateTime? filterStartDate = DateTime(1700);
  DateTime? filterEndDate = DateTime(2100);
  TextEditingController teamController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String? selectedTeam;
  String? selectedCategory;

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
                      text: LocaleData.graphicTab.getString(context),
                    ),
                    Tab(
                      text: LocaleData.listTab.getString(context),
                    ),
                  ],
                ),
                Divider(
                  height: 40,
                  color: Color.fromARGB(255, 96, 71, 36),
                  thickness: 1.5,
                  indent: screenWidth * 0.01,
                  endIndent: screenWidth * 0.01,
                ),
                SizedBox(
                  height: screenHeight * 0.75,
                  child: TabBarView(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white,
                              child: SizedBox(
                                child: FutureBuilder<List<Data>>(
                                  future: ExpenseModel.sortTime(
                                      ExpenseModel.getLeaderData(
                                          LoginPage.currentUserEmail),
                                      filterStartDate,
                                      filterEndDate,
                                      teamController.text,
                                      selectedCategory),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color:
                                              Color.fromARGB(255, 96, 71, 36),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          "${LocaleData.error.getString(context)}: ${snapshot.error}",
                                        ),
                                      );
                                    } else if (snapshot.hasData) {
                                      if (snapshot.data!.length < 2) {
                                        return Text(LocaleData
                                            .errorNotEnoughData
                                            .getString(context));
                                      } else {
                                        return SfCartesianChart(
                                          series: <LineSeries<Data, DateTime>>[
                                            LineSeries<Data, DateTime>(
                                              dataSource: snapshot.data!,
                                              color: const Color.fromRGBO(
                                                  192, 108, 132, 1),
                                              xValueMapper: (Data sales, _) =>
                                                  sales.dateOnly,
                                              yValueMapper: (Data sales, _) =>
                                                  sales.price,
                                            ),
                                            LineSeries<Data, DateTime>(
                                              dataSource:
                                                  ExpenseModel.regression(
                                                      snapshot.data!)[0],
                                              color: const Color.fromRGBO(
                                                  41, 252, 83, 1.0),
                                              xValueMapper: (Data sales, _) =>
                                                  sales.dateOnly,
                                              yValueMapper: (Data sales, _) =>
                                                  sales.price,
                                            ),
                                            LineSeries<Data, DateTime>(
                                              dataSource:
                                                  ExpenseModel.regression(
                                                      snapshot.data!)[1],
                                              color: const Color.fromRGBO(
                                                  41, 252, 83, 1.0),
                                              xValueMapper: (Data sales, _) =>
                                                  sales.dateOnly,
                                              yValueMapper: (Data sales, _) =>
                                                  sales.price,
                                            ),
                                            LineSeries<Data, DateTime>(
                                              dataSource:
                                                  ExpenseModel.regression(
                                                      snapshot.data!)[2],
                                              color: const Color.fromRGBO(
                                                  41, 252, 83, 1.0),
                                              xValueMapper: (Data sales, _) =>
                                                  sales.dateOnly,
                                              yValueMapper: (Data sales, _) =>
                                                  sales.price,
                                            )
                                          ],
                                          primaryXAxis: const DateTimeAxis(
                                            majorGridLines:
                                                MajorGridLines(width: 0),
                                            edgeLabelPlacement:
                                                EdgeLabelPlacement.shift,
                                            interval: 1,
                                          ),
                                          primaryYAxis: const NumericAxis(
                                            axisLine: AxisLine(width: 0),
                                            majorTickLines:
                                                MajorTickLines(size: 0),
                                          ),
                                        );
                                      }
                                    } else {
                                      return Center(
                                          child: Text(LocaleData.errorNoData
                                              .getString(context)));
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenWidth * 0.45,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      color: Colors.white,
                                      child: SizedBox(
                                        child: FutureBuilder<List<Data>>(
                                          future: ExpenseModel.departmentSum(
                                              ExpenseModel.getLeaderData(
                                                  LoginPage.currentUserEmail),
                                              filterStartDate,
                                              filterEndDate,
                                              teamController.text,
                                              selectedCategory),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      255, 96, 71, 36),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  "${LocaleData.error.getString(context)}: ${snapshot.error}",
                                                ),
                                              );
                                            } else if (snapshot.hasData) {
                                              return SfCartesianChart(
                                                primaryXAxis:
                                                    const CategoryAxis(),
                                                series: [
                                                  StackedColumnSeries<Data,
                                                      String>(
                                                    dataSource: snapshot.data!,
                                                    xValueMapper:
                                                        (Data sales, _) =>
                                                            sales.department,
                                                    yValueMapper:
                                                        (Data sales, _) =>
                                                            sales.price,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Center(
                                                  child: Text(LocaleData
                                                      .errorNoData
                                                      .getString(context)));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      color: Colors.white,
                                      child: SizedBox(
                                        child: FutureBuilder<List<Data>>(
                                          future: ExpenseModel.categorySum(
                                              ExpenseModel.getLeaderData(
                                                  LoginPage.currentUserEmail),
                                              filterStartDate,
                                              filterEndDate,
                                              teamController.text,
                                              selectedCategory),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      255, 96, 71, 36),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                  "${LocaleData.error.getString(context)}: ${snapshot.error}",
                                                ),
                                              );
                                            } else if (snapshot.hasData) {
                                              return SfCircularChart(
                                                legend: const Legend(
                                                    isVisible: true),
                                                series: <PieSeries<Data,
                                                    String>>[
                                                  PieSeries<Data, String>(
                                                    explode: true,
                                                    explodeIndex: 0,
                                                    dataSource: snapshot.data!,
                                                    xValueMapper:
                                                        (Data data, _) =>
                                                            data.category,
                                                    yValueMapper:
                                                        (Data data, _) =>
                                                            data.price,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                            isVisible: true),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Center(
                                                  child: Text(LocaleData
                                                      .errorNoData
                                                      .getString(context)));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: ExpenseModel.fetchTeamExpenses(LoginPage.currentUserEmail, selectedCategory),
                                    builder: (context,snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        List<ExpenseModel>? expenses = ExpenseModel.dateSort(snapshot.data!, filterStartDate, filterEndDate);
                                        double sum=0;
                                        for(var data in expenses){
                                          sum+=double.parse(data.price);
                                        }
                                        return Row(
                                          children: [
                                            Card(
                                              color: const Color.fromARGB(
                                                  255, 60, 66, 53),
                                              child: Container(
                                                width: screenWidth * 0.27,
                                                height: screenWidth * 0.22,
                                                child: Center(child: Text("${expenses.length}")),
                                              ),
                                            ),
                                            Card(
                                              color: const Color.fromARGB(255, 174, 224, 116),
                                              child: Container(
                                                width: screenWidth * 0.27,
                                                height: screenWidth * 0.22,
                                                child: Center(child: Text("$sum")),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Center(child: Text('No data available'));
                                      }

                                    }
                                ),
                                FutureBuilder(
                                    future: TeamModel.getTeamBudget(LoginPage.currentUserEmail),
                                    builder: (context,snapshot){
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        return Card(
                                          color: const Color.fromARGB(
                                              255, 60, 66, 53),
                                          child: Container(
                                            width: screenWidth * 0.27,
                                            height: screenWidth * 0.22,
                                            child: Center(child: Text("${snapshot.data}")),
                                          ),
                                        );
                                      } else {
                                        return const Center(child: Text('No data available'));
                                      }

                                    }
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder<List<ExpenseModel>>(
                        stream: ExpenseModel.fetchTeamExpenses(
                            LoginPage.currentUserEmail,selectedCategory),
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
                              child: Text(LocaleData.error.getString(context)),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: SizedBox(
                                width: screenWidth * 0.8,
                                child: Text(
                                  LocaleData.errorNoTeamExpense
                                      .getString(context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 96, 71, 36),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final expenses = ExpenseModel.dateFilter(snapshot.data!, filterStartDate, filterEndDate);
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
          LocaleData.statusDashboardWaiting.getString(context),
          Colors.lightBlue,
        ];

      case "acceptedByLeader":
        return [
          LocaleData.statusDashboardAcceptedByLeader.getString(context),
          Colors.teal,
        ];

      case "acceptedByLeaderAndFinance":
        return [
          LocaleData.statusDashboardAcceptedByLeaderAndFinance
              .getString(context),
          Colors.lightGreen,
        ];

      case "denied":
        return [
          LocaleData.statusDashboardDenied.getString(context),
          Colors.red,
        ];

      default:
        return [
          "",
          Color.fromARGB(255, 96, 71, 36),
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
                  setState(() {

                  });
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleData.dialogApplyButton.getString(context),
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
                  selectedCategory=null;
                  selectedTeam=null;
                },
                child: Text(
                  LocaleData.dialogResetButton.getString(context),
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
                  LocaleData.dialogCloseButton.getString(context),
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
              categoryDropdownMenu(),
              SizedBox(height: 150),
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
            onSelected: (String? team) {
              selectedTeam=team;
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
              color: Color.fromARGB(255, 96, 71, 36),
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
      onSelected: (String? category) {
        selectedCategory=category;
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
    ExpenseModel expense,
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
          0.93,
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
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
                        width: 10,
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
                color: statusInfoAndColor(expense)[1],
                thickness: 1.5,
              ),
              SizedBox(height: 5),
              Image.network(
                expense.image,
                height: 350,
                width: double.maxFinite,
              ),
              SizedBox(height: 10),
              infoValuePair(
                "Title",
                expense.title,
                expense,
              ),
              SizedBox(height: 2),
              infoValuePair(
                "Description",
                expense.description,
                expense,
              ),
              SizedBox(height: 2),
              infoValuePair(
                "Date",
                expense.date,
                expense,
              ),
              SizedBox(height: 2),
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
