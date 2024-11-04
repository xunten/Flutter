import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

class PraticeLevelResult extends StatefulWidget {
  const PraticeLevelResult({
    Key? key,
  }) : super(key: key);

  @override
  State<PraticeLevelResult> createState() => _PraticeLevelResultState();
}

class _PraticeLevelResultState extends State<PraticeLevelResult> {
  SharePref sharePref = SharePref();
  String? userId;
  @override
  initState() {
    log("Your User ID is ${Constant.userID}");
    super.initState();
    getUserId();
  }

  getUserId() async {
    final levelData = Provider.of<ApiProvider>(context, listen: false);
    await levelData.getPraticeLeaderBoard(Constant.userID, "today");
    debugPrint('LevelID===>${Constant.userID}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/appbg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: getAppbar(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: SizedBox(
                        child: Consumer<ApiProvider>(
                          builder: (context, userdata, child) {
                            if (userdata.loading) {
                              return usershimmer();
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyText(
                                    maltilanguage: true,
                                    title: "levelcomplite",
                                    size: 18,
                                    fontWeight: FontWeight.w500,
                                    colors: white,
                                    textalign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: primary,
                                    backgroundImage: NetworkImage(userdata
                                            .praticeLeaderboardModel
                                            .user?[0]
                                            .profileImg ??
                                        ""),
                                  ),
                                  Center(
                                    child: MyText(
                                      maltilanguage: false,
                                      title: userdata.praticeLeaderboardModel
                                              .user?[0].fullname ??
                                          "",
                                      size: 16,
                                      fontWeight: FontWeight.w500,
                                      colors: white,
                                      textalign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                        maltilanguage: false,
                                        title:
                                            "${userdata.praticeLeaderboardModel.user?[0].score} ",
                                        fontWeight: FontWeight.w500,
                                        colors: white,
                                        size: 18,
                                      ),
                                      MyText(
                                        maltilanguage: true,
                                        title: "pointeard",
                                        fontWeight: FontWeight.w500,
                                        colors: white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primary),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          side:
                                                              const BorderSide(
                                                                  color:
                                                                      white)))),
                                              child: MyText(
                                                maltilanguage: true,
                                                title: "playnext",
                                                colors: white,
                                                fontWeight: FontWeight.w500,
                                                size: 16,
                                              )),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          white),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          side:
                                                              const BorderSide(
                                                                  color:
                                                                      white)))),
                                              child: MyText(
                                                maltilanguage: true,
                                                title: "shareresult",
                                                colors: primary,
                                                fontWeight: FontWeight.w500,
                                                size: 16,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        maltilanguage: true,
        title: "levelresult",
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
      top: 280,
      bottom: 80,
      left: 0,
      right: 0,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          height: MediaQuery.of(context).size.height,
          child: Consumer<ApiProvider>(
            builder: (context, todaydata, child) {
              if (todaydata.loading) {
                return practicequestionsresultshimmer();
              }
              return ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemCount:
                    todaydata.praticeLeaderboardModel.result?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Text((index + 1).toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 16)),
                        const SizedBox(width: 15),
                        CircleAvatar(
                            minRadius: 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                '${todaydata.praticeLeaderboardModel.result?[index].profileImg}')),
                        const SizedBox(width: 10),
                        MyText(
                          title: todaydata.praticeLeaderboardModel
                                  .result?[index].fullname ??
                              "",
                          maltilanguage: false,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          colors: black,
                        ),
                        const Spacer(),
                        MyImage(
                            height: 30,
                            width: 30,
                            imagePath: "assets/images/ic_icons.png"),
                        MyText(
                          title: (todaydata.praticeLeaderboardModel
                                      .result?[index].userTotalScore ??
                                  0)
                              .toString(),
                          maltilanguage: false,
                          size: 16,
                          fontWeight: FontWeight.w500,
                          colors: black,
                        ),
                        const SizedBox(width: 15),
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
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: adview(),
        )
      ]),
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

  Widget practicequestionsresultshimmer() {
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
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomWidget.circular(
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            height: 100,
            width: 100,
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
    );
  }
}
