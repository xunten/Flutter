import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  String? userId;
  String? type = "all";
  SharePref sharePref = SharePref();
  late ApiProvider leaderboarddata;
  ApiProvider? userdata;

  @override
  initState() {
    log("User ID is ${Constant.userID}");
    getUserId();
    super.initState();
  }

  getUserId() async {
    leaderboarddata = Provider.of<ApiProvider>(context, listen: false);
    await leaderboarddata.getLeaderBoard(Constant.userID, "1");
  }

  @override
  void dispose() {
    leaderboarddata.clearprovider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Consumer<ApiProvider>(
              builder: (context, leaderdata, child) {
                if (leaderdata.loading) {
                  return Container();
                } else if (leaderdata.leaderBoardModel.status == 200 &&
                    (leaderdata.leaderBoardModel.result?.length ?? 0) > 0) {
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
                            (leaderdata.leaderBoardModel.result?.length ?? 0) >
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
                                           colors: white,
                                          ),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .leaderBoardModel
                                                        .result?[1]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata.leaderBoardModel
                                                      .result?[1].fullname ??
                                                  "",
                                              textalign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maltilanguage: false,
                                           size: 16,
                                           colors: white,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(
                                                  imagePath: "assets/images/ic_icons.png" ,height: 30,
                                              width: 30,),
                                              MyText(
                                                title: leaderdata
                                                        .leaderBoardModel
                                                        .result?[1]
                                                        .userTotalScore
                                                        .toString() ??
                                                    "",
                                               maltilanguage: false,
                                           size: 16,
                                           colors: white,
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
                                           colors: white,
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
                                              overflow: TextOverflow.ellipsis,
                                             maltilanguage: false,
                                           size: 16,
                                           colors: white,),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(
                                                  imagePath: "assets/images/ic_icons.png",height: 30,
                                              width: 30,),
                                              MyText(
                                               title:  "",
                                               maltilanguage: false,
                                           size: 16,
                                           colors: white,),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            (leaderdata.leaderBoardModel.result?.length ?? 0) >
                                    1
                                ? Expanded(
                                    child: SizedBox(
                                      height: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10),
                                          MyImage(
                                            imagePath: "assets/images/ic_user_top.png",
                                            width: 60,
                                          ),
                                          CircleAvatar(
                                            radius: 55,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .leaderBoardModel
                                                        .result?[0]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata.leaderBoardModel
                                                      .result?[0].fullname ??
                                                  "",
                                              textalign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                             maltilanguage: false,
                                           size: 16,
                                           colors: white,),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(
                                                  imagePath: "assets/images/ic_icons.png",height: 30,
                                              width: 30,),
                                              MyText(
                                                title: leaderdata
                                                        .leaderBoardModel
                                                        .result?[0]
                                                        .userTotalScore
                                                        .toString() ??
                                                    "",
                                                maltilanguage: false,
                                           size: 16,
                                           colors: white,
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
                                           colors: white,
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
                                              overflow: TextOverflow.ellipsis,
                                               maltilanguage: false,
                                           size: 16,
                                           colors: white,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                               
                                                child: MyImage(
                                                    imagePath: "assets/images/ic_icons.png" ,height: 30,
                                                width: 30,),
                                              ),
                                              MyText(
                                               title:  "",
                                                maltilanguage: false,
                                           size: 16,
                                           colors: white,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            (leaderdata.leaderBoardModel.result?.length ?? 0) >
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
                                           colors: white,
                                          ),
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderdata
                                                        .leaderBoardModel
                                                        .result?[2]
                                                        .profileImg ??
                                                    ""),
                                          ),
                                          Center(
                                            child: MyText(
                                              title: leaderdata.leaderBoardModel
                                                      .result?[2].fullname ??
                                                  "",
                                              textalign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                               maltilanguage: false,
                                           size: 16,
                                           colors: white,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyImage(
                                                 imagePath:  "assets/images/ic_icons.png", height: 30,
                                              width: 30,),
                                              MyText(
                                                title: leaderdata
                                                        .leaderBoardModel
                                                        .result?[2]
                                                        .userTotalScore
                                                        .toString() ??
                                                    "",
                                                 maltilanguage: false,
                                           size: 16,
                                           colors: white,
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
                                           colors: white,
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
                                              overflow: TextOverflow.ellipsis,
                                              maltilanguage: false,
                                           size: 16,
                                           colors: white,
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
                                           colors: white,
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
                } else {
                  return Center(
                    child:MyImage(
                      imagePath: "assets/images/nodata.png",
                      height: 250,
                      width: 250,
                    ),
                  );
                }
              },
            ),
          ),
          getAppbar(),
          buildBody(),
          getBottom(),
          Positioned.fill(
            bottom: 80,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: adview(),
            ),
          ),
        ],
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        maltilanguage: true,
        title: "leaderboard",
        colors: Colors.white,
        size: 20,
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
                return resultlistshimmer();
              } else if (leaderdata.leaderBoardModel.status == 200 &&
                  (leaderdata.leaderBoardModel.result?.length ?? 0) > 0) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: (leaderdata.leaderBoardModel.result?.length ?? 0),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              MyText(title: "${index + 1}",
                                  maltilanguage: false,
                                           size: 16,
                                           colors: black,),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                  minRadius: 25,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(leaderdata
                                          .leaderBoardModel
                                          .result?[index]
                                          .profileImg ??
                                      "")),
                              const SizedBox(width: 10),
                              MyText(
                                title: leaderdata.leaderBoardModel.result?[index]
                                        .fullname ??
                                    "",
                                 maltilanguage: false,
                                           size: 16,
                                           colors: black,
                              ),
                              const Spacer(),
                              MyImage(imagePath: "assets/images/ic_icons.png", height: 30,
                                width: 30,),
                              MyText(
                                title: leaderdata.leaderBoardModel.result?[index]
                                        .userTotalScore
                                        .toString() ??
                                    "",
                                 maltilanguage: false,
                                           size: 16,
                                           colors: black,
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ],
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
                return Center(
                  child:MyImage(
                    imagePath: "assets/images/nodata.png",
                    height: 250,
                    width: 250,
                  ),
                );
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
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: leaderSelect,
              border: Border.all(color: appColor),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          height: 60,
          child: Consumer<ApiProvider>(
            builder: (context, userdata, child) {
              if (userdata.loading) {
                return usershimmer();
              } else if (userdata.leaderBoardModel.status == 200 &&
                  (userdata.leaderBoardModel.user?.length ?? 0) > 0) {
                return Row(
                  children: [
                    const SizedBox(width: 15),
                    MyText(title: "${userdata.leaderBoardModel.user?[0].rank}",
                      maltilanguage: false,
                                           size: 16,
                                           colors: black,),
                    const SizedBox(width: 15),
                    CircleAvatar(
                        minRadius: 25,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(userdata
                                .leaderBoardModel.user?[0].profileImg
                                .toString() ??
                            "")),
                    const SizedBox(width: 10),
                    MyText(
                        maltilanguage: false,
                        title: userdata.leaderBoardModel.user?[0].fullname
                                .toString() ??
                            ""),
                    const Spacer(),
                    MyImage(imagePath: "assets/images/ic_icons.png", height: 30,
                    width: 30,),
                    MyText(
                      maltilanguage: false,
                      title: userdata.leaderBoardModel.user?[0].userTotalScore
                              .toString() ??
                          "",
                      colors: black,
                      size: 16,
                    ),
                    const SizedBox(width: 15),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget adview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: AdHelper().bannerAd(),
      ),
    );
  }

  Widget resultlistshimmer() {
    return SingleChildScrollView(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 4,
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

  Widget usershimmer() {
    return const CustomWidget.roundrectborder(
      shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      height: 50,
    );
  }

  Widget rankershimer() {
    return const Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidget.circular(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              height: 60,
              width: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: CustomWidget.roundrectborder(
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                height: 50,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidget.circular(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              height: 80,
              width: 80,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: CustomWidget.roundrectborder(
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                height: 50,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomWidget.circular(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              height: 60,
              width: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: CustomWidget.roundrectborder(
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                height: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
