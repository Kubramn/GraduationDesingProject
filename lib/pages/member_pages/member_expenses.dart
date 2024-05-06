import 'package:flutter/material.dart';

class MemberExpenses extends StatelessWidget {
  const MemberExpenses({super.key});

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
                TabBarView(children: [])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
