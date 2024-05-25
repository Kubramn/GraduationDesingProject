import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinanceRequests extends StatefulWidget {
  const FinanceRequests({super.key});

  @override
  State<FinanceRequests> createState() => _FinanceRequestsState();
}

class _FinanceRequestsState extends State<FinanceRequests> {
  User? user = FirebaseAuth.instance.currentUser;

  Align infoValuePair(String info, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$info:  ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 76, 89, 23),
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
                stream: ExpenseModel.fetchRequestsForFinance(user?.email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 76, 89, 23),
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
                            color: Color.fromARGB(255, 76, 89, 23),
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
                request.title,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              //subtitle: Text(request.description),
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      surfaceTintColor: Color.fromARGB(255, 191, 203, 155),
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
                                ElevatedButton(
                                  onPressed: (() {
                                    ExpenseModel.updateRequestStatus(
                                      request.id,
                                      "acceptedByLeaderAndFinance",
                                    );
                                    Navigator.pop(context);
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                    foregroundColor: Colors.white,
                                    fixedSize: Size(screenWidth * 0.36,
                                        screenHeight * 0.056),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                ElevatedButton(
                                  onPressed: (() {
                                    ExpenseModel.updateRequestStatus(
                                        request.id, "denied");
                                    Navigator.pop(context);
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    fixedSize: Size(screenWidth * 0.36,
                                        screenHeight * 0.056),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "Deny",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                  color: Color.fromARGB(255, 76, 89, 23),
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
                              future: UserModel.getNameSurnameByEmail(
                                  request.userEmail),
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color.fromARGB(255, 76, 89, 23),
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.025,
                                    ),
                                    Expanded(
                                      child: AutoSizeText.rich(
                                        maxLines: 2,
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
                                          ],
                                        ),
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 52, 52, 52),
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
                            infoValuePair("Title", request.title),
                            infoValuePair("Description", request.description),
                            infoValuePair("Date", request.date),
                            infoValuePair("Price", request.price),
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
