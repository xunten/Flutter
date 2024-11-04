
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

import '../../Model/contestleadermodel.dart';

class ContestLeaderBoard extends StatefulWidget {
  final int? contestId;
  const ContestLeaderBoard({Key? key, this.contestId}) : super(key: key);

  @override
  State<ContestLeaderBoard> createState() => _ContestLeaderBoardState();
}

class _ContestLeaderBoardState extends State<ContestLeaderBoard> {
  String? userId;

  SharePref sharePref = SharePref();
  List<Result>? userlist;
  List<Result>? resultlist;

  @override
  initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    userId = Constant.userID;
    debugPrint('userID===>${userId.toString()}');
    final contestleaderboarddata =
        Provider.of<ApiProvider>(context, listen: false);
    contestleaderboarddata.getContestLeaderBoard(
        Constant.userID, widget.contestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
                  Consumer<ApiProvider>(builder: (context, leaderdata, child) {
                if (leaderdata.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      Container(
                        height: 400,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/dash_bg.png"),
                          fit: BoxFit.cover,
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 15),
                            (leaderdata.contestLeaderModel.result?.length ??
                                        0) >
                                    0
                                ? Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          MyText(
                                            title: "#2",
                                            maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .contestLeaderModel
                                                        .result?[1]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata
                                                      .contestLeaderModel
                                                      .result?[1]
                                                      .username ??
                                                  "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(
                                                  imagePath: "assets/images/ic_icons.png",height: 30,width: 30,),
                                              MyText(
                                                title: leaderdata
                                                        .contestLeaderModel
                                                        .result?[1]
                                                        .score
                                                        .toString() ??
                                                    "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          MyText(
                                            title: "#2",
                                            maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                          ),
                                          Center(
                                            child: MyText(
                                              title: "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(height: 30,width: 30,
                                                  imagePath: "assets/images/ic_icons.png"),
                                              MyText(
                                                title: "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            (leaderdata.contestLeaderModel.result?.length ??
                                        0) >
                                    1
                                ? Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10),
                                          Image.asset(
                                            "assets/images/ic_user_top.png",
                                            width: 60,
                                          ),
                                          CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .contestLeaderModel
                                                        .result?[0]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata
                                                      .contestLeaderModel
                                                      .result?[0]
                                                      .username ??
                                                  "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(height: 30,width: 30,
                                                  imagePath: "assets/images/ic_icons.png"),
                                              MyText(
                                                title: leaderdata
                                                        .contestLeaderModel
                                                        .result?[0]
                                                        .score
                                                        .toString() ??
                                                    "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          MyText(
                                            title: "#3",
                                            maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(height: 30,width: 30,
                                                  imagePath: "assets/images/ic_icons.png"),
                                              MyText(
                                                title: "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            (leaderdata.contestLeaderModel.result?.length ??
                                        0) >
                                    2
                                ? Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          MyText(
                                            title: "#3",
                                            maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .contestLeaderModel
                                                        .result?[2]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata
                                                      .contestLeaderModel
                                                      .result?[2]
                                                      .username ??
                                                  "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(height: 30,width: 30,
                                                  imagePath: "assets/images/ic_icons.png"),
                                              MyText(
                                                title: leaderdata
                                                        .contestLeaderModel
                                                        .result?[2]
                                                        .score
                                                        .toString() ??
                                                    "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          MyText(
                                            title: "#3",
                                            maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: "",
                                              textalign: TextAlign.center,
                                              maltilanguage: false,
                                              size: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(height: 30,width: 30,
                                                 imagePath:  "assets/images/ic_icons.png"),
                                              MyText(
                                                title: "",
                                                maltilanguage: false,
                                                size: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            getAppbar(),
            buildBody(),
            getBottom()
          ],
        ),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        title: "leaderboard",
        maltilanguage: true,
        size: 20,
        colors: Colors.white,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  buildBody() {
    return Positioned.fill(
      top: 350,
      bottom: 80,
      left: 0,
      right: 0,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          height: MediaQuery.of(context).size.height,
          child: Consumer<ApiProvider>(
            builder: (context, leaderdata, child) {
              if (leaderdata.loading) {
                return CircularPercentIndicator(radius: 10);
              } else {
                resultlist = leaderdata.contestLeaderModel.result;
                if ((resultlist?.length ?? 0) > 0) {
                  resultlist?.removeRange(0, 2);
                }
                if ((resultlist?.length ?? 0) > 0) {
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: (resultlist?.length ?? 0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            MyText(title: (index + 3).toString(),
                             maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,),
                            const SizedBox(width: 15),
                            CircleAvatar(
                                minRadius: 25,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(leaderdata
                                        .contestLeaderModel
                                        .result?[index]
                                        .profileImg ??
                                    "")),
                            const SizedBox(width: 10),
                            MyText(
                              title: leaderdata.contestLeaderModel.result?[index]
                                      .username ??
                                  "",
                             maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyImage(height: 30,width: 30,
                                      imagePath: "assets/images/ic_icons.png"),
                                  MyText(
                                    title: leaderdata.contestLeaderModel.result?[index]
                                            .score
                                            .toString() ??
                                        "",
                                 maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(height: 1, thickness: 1),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ),
      ]),
    );
  }

  getBottom() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<ApiProvider>(
          builder: (context, userdata, child) {
            if (userdata.loading) {
              return Container();
            } else {
              userlist = userdata.contestLeaderModel.user;
              log("===>list ${userlist?.length}");
              if ((userlist?.length ?? 0) > 0) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: leaderSelect,
                      border: Border.all(color: appColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
                  height: 60,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      MyText(title: "1",
                         maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,),
                      const SizedBox(width: 15),
                      CircleAvatar(
                          minRadius: 25,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              userdata.contestLeaderModel.user?[0].profileImg ??
                                  "")),
                      const SizedBox(width: 10),
                      MyText(
                          maltilanguage: false,
                          title:
                              userdata.contestLeaderModel.user?[0].username ??
                                  ""),
                      const Spacer(),
                      MyImage(height: 30,width: 30,imagePath: "assets/images/ic_icons.png"),
                      MyText(
                        maltilanguage: false,
                        title: userdata.contestLeaderModel.user?[0].score
                                .toString() ??
                            "",
                        colors: black,
                        size: 16,
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
