import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/contest/contestleaderboard.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import 'package:shimmer/shimmer.dart';
import 'contestquestions.dart';

class Contest extends StatefulWidget {
  const Contest({Key? key}) : super(key: key);

  @override
  State<Contest> createState() => _ContestState();
}

class _ContestState extends State<Contest> {
  SharePref sharePref = SharePref();
  String? userId;
  var bannerad = "";
  var banneradIos = "";

  @override
  initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final upcomingdata = Provider.of<ApiProvider>(context, listen: false);
    upcomingdata.getUpContent('upcoming', Constant.userID ?? "");
    upcomingdata.getLiveContent(context, 'live', Constant.userID ?? "");
    upcomingdata.getEndContent(context, 'ended', Constant.userID ?? "");
    userId = Constant.userID;
    debugPrint('userID===>${userId.toString()}');
    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  getAppbar() {
    return const MyAppbar(
      title: "contest",
    );
  }

  buildBody() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                getAppbar(),
                const SizedBox(height: 10),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: tabbarunselect,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(25.0)),
                    labelColor: appColor,
                    unselectedLabelColor: white,
                    tabs: [
                      MyText(
                          title: 'upcoming',
                          maltilanguage: true,
                          fontfamilyInter: true,
                          size: 16,
                          fontWeight: FontWeight.w500),
                      MyText(
                          title: 'live',
                          maltilanguage: true,
                          fontfamilyInter: true,
                          size: 16,
                          fontWeight: FontWeight.w500),
                      MyText(
                          title: 'ended',
                          maltilanguage: true,
                          fontfamilyInter: true,
                          size: 16,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [upcoming(), live(), ended()],
                )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    color: Colors.transparent,
                    height: 60,
                    child: AdHelper().bannerAd(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  upcoming() {
    return Consumer<ApiProvider>(
      builder: (context, upcomingdata, child) {
        return upcomingdata.loading
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  );
                },
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: upcomingdata.upcontentModel.result?.length ?? 0,
                itemBuilder: (context, index) {
                  DateTime date1 = DateTime.parse(
                      (upcomingdata.upcontentModel.result?[index].startDate ??
                          ""));
                  DateTime now = DateTime.now();
                  debugPrint(now.toString());
                  debugPrint(date1.toString());

                  Duration diff = date1.difference(now);

                  debugPrint('===> ${diff.inDays}');

                  return Container(
                    margin: const EdgeInsets.only(
                        left: 5, top: 10, right: 5, bottom: 5),
                    height: 230,
                    decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      child: Column(children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                MyText(
                                    maltilanguage: true,
                                    title: 'pricepool',
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                    colors: textColorGrey),
                                MyText(
                                    maltilanguage: false,
                                    title: upcomingdata.upcontentModel
                                            .result?[index].totalPrize
                                            .toString() ??
                                        "",
                                    size: 24,
                                    fontWeight: FontWeight.w600,
                                    colors: black)
                              ],
                            ),
                            const Spacer(),
                            (upcomingdata.upcontentModel.result?[index].isBuy ??
                                        0) ==
                                    0
                                ? TextButton(
                                    onPressed: () async {
                                      final joinContest =
                                          Provider.of<ApiProvider>(context,
                                              listen: false);
                                      await joinContest.getjoinContest(
                                          upcomingdata.upcontentModel
                                                  .result?[index].id
                                                  .toString() ??
                                              "",
                                          Constant.userID.toString(),
                                          upcomingdata.upcontentModel
                                                  .result?[index].price
                                                  .toString() ??
                                              "");
                                      if (!joinContest.loading) {
                                        Utility.toastMessage(joinContest
                                            .successModel.message
                                            .toString());
                                      }
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        28.0))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                appColor)),
                                    child: MyText(
                                      maltilanguage: true,
                                      title: 'joinnow',
                                      size: 16,
                                      fontWeight: FontWeight.w500,
                                      colors: white,
                                    ))
                                : Container(),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            MyImage(
                              imagePath: "assets/images/ic_trophy.png",
                              height: 15,
                              width: 15,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                maltilanguage: true,
                                title: 'winner:',
                                size: 16,
                                fontWeight: FontWeight.w400,
                                colors: textColorGree),
                            MyText(
                                maltilanguage: false,
                                title:
                                    ' ${upcomingdata.upcontentModel.result?[index].noOfUserPrize ?? ""}',
                                size: 16,
                                fontWeight: FontWeight.w400,
                                colors: textColorGree),
                            const Spacer(),
                            MyText(
                                maltilanguage: false,
                                title: upcomingdata
                                        .upcontentModel.result?[index].name ??
                                    "",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: black)
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearPercentIndicator(
                          animation: true,
                          lineHeight: 5,
                          animationDuration: 2500,
                          percent: 0.8,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: appColor,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            MyText(
                                maltilanguage: true,
                                title: "150left",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: red),
                            const Spacer(),
                            MyText(
                                maltilanguage: false,
                                title:
                                    "${upcomingdata.upcontentModel.result?[index].noOfUser ?? ""} ",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: textColorGrey),
                            MyText(
                                maltilanguage: true,
                                title: "total",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: textColorGrey),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 0.5, color: textColorGrey),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: true,
                                          title: 'start',
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: false,
                                          title: diff.inDays > 1
                                              ? Utility().dateConvert(
                                                  upcomingdata
                                                          .upcontentModel
                                                          .result?[index]
                                                          .startDate ??
                                                      "",
                                                  "dd-MMM-yy")
                                              : "${diff.inHours} h - ${diff.inMinutes} m - ${diff.inSeconds} m - ",
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                width: 1,
                                color: textColorGrey,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: true,
                                          title: 'entryfee',
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: false,
                                          title: upcomingdata.upcontentModel
                                                  .result?[index].price ??
                                              "",
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                width: 1,
                                color: textColorGrey,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: true,
                                          title: 'end',
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Expanded(
                                      child: MyText(
                                          maltilanguage: false,
                                          title: Utility().dateConvert(
                                              upcomingdata.upcontentModel
                                                      .result?[index].endDate ??
                                                  "",
                                              "dd-MMM-yy"),
                                          size: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
                },
              );
      },
    );
  }

  live() {
    return Consumer<ApiProvider>(
      builder: (context, livecontent, child) {
        return livecontent.loading
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  );
                },
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: livecontent.livecontentModel.result?.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 5, top: 10, right: 5, bottom: 5),
                    height: 165,
                    decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      child: Column(children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                MyText(
                                    maltilanguage: true,
                                    title: "pricepool",
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                    colors: textColorGrey),
                                MyText(
                                    maltilanguage: false,
                                    title: livecontent.livecontentModel
                                            .result?[index].totalPrize
                                            .toString() ??
                                        "",
                                    size: 24,
                                    fontWeight: FontWeight.w600,
                                    colors: black)
                              ],
                            ),
                            const Spacer(),
                            (livecontent.livecontentModel.result?[index]
                                            .isPlayed ??
                                        0) ==
                                    0
                                ? TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContestQuestions(
                                                    contestId: livecontent
                                                        .livecontentModel
                                                        .result?[index]
                                                        .id
                                                        .toString(),
                                                    contestName: livecontent
                                                        .livecontentModel
                                                        .result?[index]
                                                        .name,
                                                  )));
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        28.0))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                appColor)),
                                    child: MyText(
                                      maltilanguage: true,
                                      title: 'playnow',
                                      size: 16,
                                      fontWeight: FontWeight.w500,
                                      colors: white,
                                    ))
                                : MyText(
                                    maltilanguage: true,
                                    title: 'alreadyplayed',
                                    fontWeight: FontWeight.w500,
                                    colors: red,
                                    size: 14,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            MyImage(
                              imagePath: "assets/images/ic_trophy.png",
                              height: 15,
                              width: 15,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                title: "winner:",
                                maltilanguage: true,
                                size: 16,
                                fontWeight: FontWeight.w400,
                                colors: textColorGree),
                            const SizedBox(width: 5),
                            MyText(
                                maltilanguage: false,
                                title:
                                    "${livecontent.livecontentModel.result?[index].noOfUserPrize}",
                                size: 16,
                                fontWeight: FontWeight.w400,
                                colors: textColorGree),
                            const Spacer(),
                            MyText(
                                maltilanguage: false,
                                title: livecontent
                                        .livecontentModel.result?[index].name ??
                                    "",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                maxline: 1,
                                colors: black)
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: textColorGrey),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                  maltilanguage: true,
                                  title: "5h40m",
                                  size: 16,
                                  fontWeight: FontWeight.w600),
                              const VerticalDivider(
                                thickness: 2,
                                width: 20,
                                color: textColorGrey,
                              ),
                              MyText(
                                  title: "entryfee",
                                  maltilanguage: true,
                                  size: 16,
                                  fontWeight: FontWeight.w600),
                              MyText(
                                  maltilanguage: false,
                                  title:
                                      " ${livecontent.livecontentModel.result?[index].price}",
                                  size: 16,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
                },
              );
      },
    );
  }

  ended() {
    return Consumer<ApiProvider>(
      builder: (context, endcontent, child) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: endcontent.endcontentModel.result?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
              height: 160,
              decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, right: 10, bottom: 10),
                child: Column(children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          MyText(
                              maltilanguage: true,
                              title: "pricepool",
                              size: 16,
                              fontWeight: FontWeight.w400,
                              colors: textColorGrey),
                          MyText(
                              maltilanguage: false,
                              title: endcontent
                                      .endcontentModel.result?[index].totalPrize
                                      .toString() ??
                                  "",
                              size: 24,
                              textalign: TextAlign.left,
                              fontWeight: FontWeight.w600,
                              colors: black)
                        ],
                      ),
                      const Spacer(),
                      MyText(
                          maltilanguage: true,
                          title: "entryfee",
                          size: 16,
                          fontWeight: FontWeight.w600,
                          colors: black),
                      MyText(
                          maltilanguage: false,
                          title:
                              " ${endcontent.endcontentModel.result?[index].price}",
                          size: 16,
                          fontWeight: FontWeight.w600,
                          colors: black),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      MyImage(
                        imagePath: "assets/images/ic_trophy.png",
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(width: 5),
                      MyText(title: "winner:", maltilanguage: true),
                      MyText(
                          maltilanguage: false,
                          title: endcontent
                                  .endcontentModel.result?[index].noOfUserPrize
                                  .toString() ??
                              "",
                          size: 16,
                          fontWeight: FontWeight.w400,
                          colors: textColorGree),
                      const Spacer(),
                      MyText(
                          maltilanguage: false,
                          title:
                              endcontent.endcontentModel.result?[index].name ??
                                  "",
                          size: 17,
                          fontWeight: FontWeight.w600,
                          colors: black)
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 0.2, color: textColorGrey),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContestLeaderBoard(
                                        contestId: endcontent
                                            .endcontentModel.result?[index].id,
                                      )));
                        },
                        child: MyText(
                            maltilanguage: true,
                            title: "leaderboard",
                            size: 16,
                            fontWeight: FontWeight.w600,
                            colors: appColor),
                      ),
                      const Spacer(),
                      MyText(
                          maltilanguage: true,
                          title: "statistics",
                          size: 16,
                          fontWeight: FontWeight.w600,
                          colors: appColor),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          winnerList(
                              endcontent.endcontentModel.result?[index].id);
                        },
                        child: MyText(
                            maltilanguage: true,
                            title: "winnerdetail",
                            size: 16,
                            fontWeight: FontWeight.w600,
                            colors: appColor),
                      ),
                    ],
                  )
                ]),
              ),
            );
          },
        );
      },
    );
  }

  void winnerList(var contestId) {
    final winnerdata = Provider.of<ApiProvider>(context, listen: false);
    winnerdata.getContestWinnerList(contestId.toString());

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: primary,
                    child: Row(
                      children: [
                        Expanded(
                            child: MyText(
                          maltilanguage: true,
                          title: "rank",
                          textalign: TextAlign.center,
                          size: 16,
                          fontWeight: FontWeight.w600,
                          maxline: 1,
                          colors: white,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Expanded(
                            child: MyText(
                          maltilanguage: true,
                          title: "name",
                          textalign: TextAlign.center,
                          size: 16,
                          fontWeight: FontWeight.w600,
                          maxline: 1,
                          colors: white,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Expanded(
                            child: MyText(
                          maltilanguage: true,
                          title: "winnings",
                          textalign: TextAlign.center,
                          size: 16,
                          colors: white,
                          fontWeight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                  ),
                  ListView.separated(
                    itemCount: winnerdata.winnerModel.result?.length ?? 0,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: MyText(
                                  maltilanguage: false,
                                  title: (winnerdata.winnerModel.result?[index]
                                              .rank ??
                                          0)
                                      .toString(),
                                  textalign: TextAlign.center,
                                  size: 16,
                                  fontWeight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath:
                                            "assets/images/ic_icons.png"),
                                    Expanded(
                                      flex: 2,
                                      child: MyText(
                                        maltilanguage: false,
                                        title: (winnerdata.winnerModel
                                                    .result?[index].fullname ??
                                                "")
                                            .toString(),
                                        textalign: TextAlign.center,
                                        size: 16,
                                        fontWeight: FontWeight.w600,
                                        maxline: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              child: MyText(
                                maltilanguage: false,
                                title: (winnerdata
                                            .winnerModel.result?[index].price ??
                                        0)
                                    .toString(),
                                textalign: TextAlign.center,
                                size: 16,
                                fontWeight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: textColorGrey,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
