import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import '../widget/myappbar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  SharePref sharePref = SharePref();

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    log("User ID Is == ${Constant.userID}");
    final notificationProvider =
        Provider.of<ApiProvider>(context, listen: false);
    notificationProvider.getNotification(context, Constant.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              getAppbar(),
              const SizedBox(height: 30),
              buildWebview(),
             
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child:  Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  color: Colors.transparent,
                  height: 60,
                  child: AdHelper().bannerAd(),
                ),
              ),
        )
      ]),
    );
  }

  getAppbar() {
    return const MyAppbar(
      title: "notification",
    );
  }

  Widget buildWebview() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
            color: white,
            child: Consumer<ApiProvider>(
              builder: (context, notificationData, child) {
                if (notificationData.loading) {
                  return notificationshimer();
                } else {
                  if (notificationData.notificationModel.status == 200 &&
                      notificationData.notificationModel.result!.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount:
                          notificationData.notificationModel.result?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 3,
                            color: lightgray,
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                CircleAvatar(
                                    radius: (20),
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child:MyImage(
                                          imagePath: "assets/images/ic_quiz.png"),
                                    )),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        maltilanguage: false,
                                        title: notificationData
                                            .notificationModel
                                            .result?[index]
                                            .headings
                                            .toString(),
                                        maxline: 1,
                                        fontWeight: FontWeight.w800,
                                        size: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      MyText(
                                        maltilanguage: false,
                                        title: notificationData
                                            .notificationModel
                                            .result?[index]
                                            .contents
                                            .toString(),
                                        maxline: 2,
                                        fontWeight: FontWeight.w400,
                                        size: 13,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () async {
                                    var notificationProvider =
                                        Provider.of<ApiProvider>(context,
                                            listen: false);

                                    await notificationProvider
                                        .getReadNotification(
                                            Constant.userID,
                                            notificationData.notificationModel
                                                .result?[index].id);
                                    if (!notificationProvider.loading) {
                                      Utility.toastMessage("Success");
                                      notificationProvider.getNotification(
                                          context, Constant.userID);
                                    }
                                  },
                                  child: CircleAvatar(
                                      radius: 15,
                                      child: ClipRRect(
                                        child: MyImage(
                                           imagePath:  "assets/images/ic_del.png"),
                                      )),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: SizedBox(
                            child: MyText(
                      maltilanguage: true,
                      title: "notificationnotfound",
                      fontWeight: FontWeight.w800,
                      size: 20,
                    )));
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget notificationshimer() {
    return SingleChildScrollView(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 8,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 5.0),
        itemBuilder: (BuildContext context, int index) {
          return const CustomWidget.roundrectborder(
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            height: 50,
          );
        },
      ),
    );
  }
}
