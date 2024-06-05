import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';

class LeaderRequests extends StatefulWidget {
  const LeaderRequests({super.key});

  @override
  State<LeaderRequests> createState() => _LeaderRequestsState();
}

class _LeaderRequestsState extends State<LeaderRequests> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 225),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              height: screenHeight * 0.75,
              child: StreamBuilder<List<ExpenseModel>>(
                stream: ExpenseModel.fetchRequestsForLeader(
                    LoginPage.currentUserEmail),
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
                        return Column(
                          children: [
                            requestTile(
                              requests[index],
                              screenHeight,
                              screenWidth,
                            ),
                            SizedBox(height: 10),
                          ],
                        );
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

  Widget infoValuePair(String info, String value) {
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

  Widget requestTile(
    ExpenseModel request,
    double screenHeight,
    double screenWidth,
  ) =>
      SizedBox(
        height: 80,
        child: Card(
          elevation: 3,
          shadowColor: Color.fromARGB(255, 187, 179, 203),
          color: Colors.white,
          surfaceTintColor: Color.fromARGB(255, 187, 179, 203),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: ListTile(
              textColor: Color.fromARGB(255, 52, 52, 52),
              leading: Icon(
                Icons.attach_money,
                color: Color.fromARGB(255, 68, 60, 95),
                size: 34,
              ),
              title: Text(
                request.title,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 68, 60, 95),
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 187, 179, 203),
                ),
                onPressed: () {
                  showRequestDialog(screenWidth, screenHeight, request);
                },
              ),
            ),
          ),
        ),
      );

  Future<dynamic> showRequestDialog(
      double screenWidth, double screenHeight, ExpenseModel request) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Color.fromARGB(255, 187, 179, 203),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
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
                        "acceptedByLeader",
                      );
                      Navigator.pop(context);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      fixedSize: Size(160, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Accept",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      ExpenseModel.updateRequestStatus(request.id, "denied");
                      Navigator.pop(context);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      fixedSize: Size(160, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Deny",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 187, 179, 203),
                ),
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
                future: UserModel.getNameSurnameByEmail(request.userEmail),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color.fromARGB(255, 68, 60, 95),
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: AutoSizeText.rich(
                          maxLines: 2,
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
                            ],
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 68, 60, 95),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Divider(
                color: Color.fromARGB(255, 68, 60, 95),
                thickness: 1.5,
              ),
              SizedBox(height: 5),
              Image.network(
                request.image,
                height: 350,
                width: double.maxFinite,
              ),
              SizedBox(height: 10),
              infoValuePair("Title", request.title),
              SizedBox(height: 2),
              infoValuePair("Description", request.description),
              SizedBox(height: 2),
              infoValuePair("Date", request.date),
              SizedBox(height: 2),
              infoValuePair("Price", request.price),
            ],
          ),
        ),
      ),
    );
  }
}
