import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitirme/localization/locales.dart';
import 'package:bitirme/models/expense_model.dart';
import 'package:bitirme/models/user_model.dart';
import 'package:bitirme/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class FinanceRequests extends StatefulWidget {
  const FinanceRequests({super.key});

  @override
  State<FinanceRequests> createState() => _FinanceRequestsState();
}

class _FinanceRequestsState extends State<FinanceRequests> {
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
                stream: ExpenseModel.fetchRequestsForFinance(
                  LoginPage.currentUserEmail,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 76, 89, 23),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(LocaleData.error.getString(context)),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: SizedBox(
                        width: screenWidth * 0.8,
                        child: Text(
                          LocaleData.errorNoTeamRequestFinance
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
                color: Color.fromARGB(255, 76, 89, 23),
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
          shadowColor: Color.fromARGB(255, 191, 203, 155),
          color: Colors.white,
          surfaceTintColor: Color.fromARGB(255, 191, 203, 155),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
              trailing: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 76, 89, 23),
                  size: 30,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 191, 203, 155),
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
        surfaceTintColor: Color.fromARGB(255, 191, 203, 155),
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
                        "acceptedByLeaderAndFinance",
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
                      LocaleData.dialogAcceptButton.getString(context),
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
                      LocaleData.dialogDenyButton.getString(context),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 191, 203, 155),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleData.dialogCloseButton.getString(context),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 76, 89, 23),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
        content: RawScrollbar(
          radius: const Radius.circular(100),
          thumbColor: Color.fromARGB(255, 191, 203, 155),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: UserModel.getNameSurnameByEmail(request.userEmail),
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color.fromARGB(255, 76, 89, 23),
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AutoSizeText.rich(
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 20,
                              minFontSize: 20,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: LocaleData.statusRequestsIntro
                                        .getString(context),
                                  ),
                                  TextSpan(
                                    text: snapshot.data,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 52, 52, 52),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 76, 89, 23),
                    thickness: 1.5,
                    height: 25,
                  ),
                  const SizedBox(height: 5),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 350),
                    child: Image.network(
                      request.image,
                    ),
                  ),
                  const SizedBox(height: 15),
                  infoValuePair(
                    LocaleData.dialogTitle.getString(context),
                    request.title,
                  ),
                  const SizedBox(height: 10),
                  infoValuePair(
                    LocaleData.dialogDescription.getString(context),
                    request.description,
                  ),
                  const SizedBox(height: 10),
                  infoValuePair(
                    LocaleData.dialogDate.getString(context),
                    request.date,
                  ),
                  const SizedBox(height: 10),
                  infoValuePair(
                    LocaleData.dialogPrice.getString(context),
                    request.price,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
