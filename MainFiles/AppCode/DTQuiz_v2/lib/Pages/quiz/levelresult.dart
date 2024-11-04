import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mynetimage.dart';
import 'package:quizapp/widget/mytext.dart';

class LevelResult extends StatefulWidget {
  final String? levelId;
  final int resulttype;
  const LevelResult({Key? key, this.levelId, required this.resulttype})
      : super(key: key);

  @override
  State<LevelResult> createState() => _LevelResultState();
}

class _LevelResultState extends State<LevelResult> {
  SharePref sharePref = SharePref();
  late ApiProvider levelData;
  late ApiProvider userdata;
  @override
  void initState() {
    log("User ID is ===>>> ${Constant.userID}");
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    levelData.clearprovider();
    userdata.clearprovider();
    super.dispose();
  }

  getUserId() async {
    levelData = Provider.of<ApiProvider>(context, listen: false);
    if (widget.resulttype == 1) {
      log("Normal Leaderboard Calling");
      await levelData.getTodayLeaderBoard(Constant.userID, widget.levelId ?? "");
      Utility.toastMessage("today Questions Leaderboard ");
    } else if (widget.resulttype == 2) {
      log("Audio Leaderboard Calling");
      await levelData.getAudioLeaderBoard(Constant.userID, "today");
      Utility.toastMessage("Audio Questions Leaderboard ");
    } else if (widget.resulttype == 3) {
      log("Video Leaderboard Calling");
      await levelData.getVideoLeaderBoard(Constant.userID, "today");
      Utility.toastMessage("Video Questions Leaderboard ");
    } else if (widget.resulttype == 4) {
      log("TrueFalse Leaderboard Calling");
      await levelData.getTrueFalseLeaderBoard(Constant.userID, "month");
      Utility.toastMessage("TrueFalse Questions Leaderboard ");
      log("TrueFalse Quiz Leaderboard ====>>> ${levelData.todayLeaderBoardModel.user?[0].score.toString()}");
    } else if (widget.resulttype == 5) {
      log("Daily Quiz Leaderboard Calling");
      await levelData.getDailyQuizLeaderBoard(Constant.userID, "today");
      Utility.toastMessage("Daily Quiz Questions Leaderboard ");
    }
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
                              log("score of api  === ${userdata.todayLeaderBoardModel.user?[0].score ?? ""}");
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                              
                                  const SizedBox(height: 10),
                                
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: userdata.todayLeaderBoardModel
                                                .user?[0].profileImg ==
                                            ""
                                        ? MyImage(
                                            imagePath: "assets/images/ic_user_dummy.png",
                                            height: 90,
                                            width: 100,
                                          )
                                        : MyNetImage(
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 90,
                                            imagePath: userdata
                                                    .todayLeaderBoardModel
                                                    .user?[0]
                                                    .profileImg ??
                                                ""),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: MyText(
                                      maltilanguage: false,
                                      title: userdata.todayLeaderBoardModel
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
                                            "${userdata.todayLeaderBoardModel.user?[0].score} ",
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
        title: "levelresult",
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
                return questionsresultshimmer();
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount:
                      todaydata.todayLeaderBoardModel.result?.length ?? 0,
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
                                  '${todaydata.todayLeaderBoardModel.result?[index].profileImg}')),
                          const SizedBox(width: 10),
                          MyText(
                            title: todaydata.todayLeaderBoardModel.result?[index]
                                    .fullname ??
                                "",
                          maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,colors: black,
                          ),
                          const Spacer(),
                          MyImage(height: 30,width: 30,imagePath: "assets/images/ic_icons.png"),
                          MyText(
                            title: (todaydata.todayLeaderBoardModel.result?[index]
                                        .score ??
                                    0)
                                .toString(),
                         maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w500,colors: black,
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
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget questionsresultshimmer() {
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
