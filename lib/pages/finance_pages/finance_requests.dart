import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceRequests extends StatefulWidget {
  const FinanceRequests({super.key});

  @override
  State<FinanceRequests> createState() => _FinanceRequestsState();
}

class _FinanceRequestsState extends State<FinanceRequests> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<String> getNameSurname(String email) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    final data = userDoc.docs.first.data();
    return "${data['name']} ${data['surname']}";
  }

  Stream<List<ExpenseModel>> fetchRequests() {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where(
          Filter.or(
            Filter.and(
              Filter("checkerUserEmail", isEqualTo: user?.email),
              Filter("status", isEqualTo: "waiting"),
            ),
            Filter("status", isEqualTo: "acceptedByLeader"),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Container(
              //color: Colors.black,
              height: screenHeight * 0.8,
              child: StreamBuilder<List<ExpenseModel>>(
                stream: fetchRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 68, 60, 95),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('ERROR!'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: SizedBox(
                        width: screenWidth * 0.8,
                        child: Text(
                          "There is no expense request from your team right now.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 68, 60, 95),
                          ),
                        ),
                      ),
                    );
                  } else {
                    List<ExpenseModel> requests = snapshot.data!;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        return requestTile(
                            requests[index], screenHeight, screenWidth);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestTile(
    ExpenseModel request,
    double screenHeight,
    double screenWidth,
  ) =>
      SizedBox(
        height: screenHeight * 0.08,
        child: Card(
          elevation: 3,
          shadowColor: Color.fromARGB(255, 187, 179, 203),
          color: Colors.white,
          surfaceTintColor: Color.fromARGB(255, 187, 179, 203),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: ListTile(
              textColor: Color.fromARGB(255, 52, 52, 52),
              leading: Icon(
                Icons.attach_money,
                color: Color.fromARGB(255, 68, 60, 95),
                size: 32,
              ),
              title: Text(
                request.title,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              //subtitle: Text(request.description),
              trailing: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 68, 60, 95),
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 187, 179, 203),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      surfaceTintColor: Color.fromARGB(255, 187, 179, 203),
                      backgroundColor: Colors.white,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.15,
                      ),
                      actions: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AcceptOrDeny(
                                  acceptOrDeny: "Accept",
                                  textColor: Colors.lightGreen,
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                AcceptOrDeny(
                                  acceptOrDeny: "Deny",
                                  textColor: Colors.red,
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 68, 60, 95),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                      content: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FutureBuilder<String>(
                              future: getNameSurname(request.userEmail),
                              builder: (context, snapshot) {
                                return AutoSizeText.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "This expense was incurred by "),
                                      TextSpan(
                                        text: snapshot.data,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 52, 52, 52),
                                    fontSize: 30,
                                  ),
                                );
                              },
                            ),
                            Divider(
                              color: Color.fromARGB(255, 68, 60, 95),
                              thickness: 2,
                            ),
                            InfoValue(
                              info: "Title",
                              value: request.title,
                            ),
                            InfoValue(
                              info: "Description",
                              value: request.description,
                            ),
                            InfoValue(
                              info: "Date",
                              value: DateFormat('MMMM d, yyyy')
                                  .format(request.date),
                            ),
                            InfoValue(
                              info: "Price",
                              value: request.price,
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

class AcceptOrDeny extends StatelessWidget {
  final String acceptOrDeny;
  final Color textColor;
  final double screenHeight;
  final double screenWidth;

  const AcceptOrDeny({
    super.key,
    required this.acceptOrDeny,
    required this.textColor,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 68, 60, 95),
        foregroundColor: textColor,
        fixedSize: Size(screenWidth * 0.36, screenHeight * 0.056),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        acceptOrDeny,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
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
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$info:  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 68, 60, 95),
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
}
