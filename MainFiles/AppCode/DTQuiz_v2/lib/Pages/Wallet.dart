import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/redeem.dart';
import 'package:quizapp/Pages/subscription/subscription.dart';
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

bool topBar = false;

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? userId,
      strEarnpoint,
      strEarnamount,
      strMinimumpoint,
      strCurrency,
      strWalletVisible;

  SharePref sharePref = SharePref();

  @override
  void initState() {
    userId = Constant.userID;
    getUserId();

    super.initState();
  }

  getUserId() async {
    final profiledata = Provider.of<ApiProvider>(context, listen: false);
    await profiledata.getProfile(context, Constant.userID ?? "");
    await profiledata.getCoinsHistory(Constant.userID ?? "");
    await profiledata.getRewardPoints(Constant.userID ?? "");
    await profiledata.getEarnPoints(Constant.userID ?? "");
    await profiledata.getReferTransaction(Constant.userID ?? "");
    await profiledata.getWithdrawalList(Constant.userID ?? "");

    debugPrint('userID===>${userId.toString()}');
    strEarnpoint = await sharePref.read('earning_point') ?? "0";
    strEarnamount = await sharePref.read('earning_amount') ?? "0";
    strMinimumpoint = await sharePref.read('min_earning_point') ?? "0";
    strCurrency = await sharePref.read('currency') ?? "0";
    strWalletVisible =
        await sharePref.read('wallet_withdraw_visibility') ?? "0";
    debugPrint('strEarnpoint===>${strEarnpoint.toString()}');
    log('====> $strMinimumpoint');
    log("Wallet visibilty ===>>> $strWalletVisible");
  }

  @override
  Widget build(BuildContext context) {
    log("called");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBgColor,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Stack(children: [
                    Container(
                      height: 460,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/dash_bg.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(50.0, 50.0)),
                      ),
                    ),
                    Column(
                      children: [
                        getAppbar(),
                        buildBody(),
                      ],
                    ),
                  ]),
                ],
              ),
              DefaultTabController(length: 5, child: buildPager())
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
    return const MyAppbar(title: "Wallet");
  }

  buildBody() {
    return Consumer<ApiProvider>(
      builder: (context, profiledata, child) {
        if (profiledata.loading) {
          return Padding(
              padding: const EdgeInsets.only(left: 10), child: pointsshimmer());
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Column(children: [
              Row(
                children: [
                  MyImage(
                    width: 200,
                    height: 200,
                    imagePath: 'assets/images/ic_reward_coins.png',
                    fit: BoxFit.cover,
                  ),
                  Column(
                    children: [
                      MyText(
                        size: 30,
                        colors: white,
                        fontWeight: FontWeight.w600,
                        maltilanguage: false,
                        title: profiledata.profileModel.result?[0].totalPoints
                                .toString() ??
                            "00",
                      ),
                      MyText(
                        maltilanguage: false,
                        title: "points",
                        size: 25,
                        fontWeight: FontWeight.w500,
                        colors: white,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  strWalletVisible == "yes"
                      ? Expanded(
                        child: InkWell(
                            onTap: () {
                              int? totalPoints = int.tryParse(profiledata
                                      .profileModel.result?[0].totalPoints
                                      .toString() ??
                                  "");
                              int? minimumPoints =
                                  int.tryParse(strMinimumpoint ?? "");
                              if (totalPoints! > minimumPoints!) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Redeem()));
                              } else {
                                Utility.toastMessage(
                                    "Minimum $strMinimumpoint Points Required ");
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 49,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyImage(
                                      width: 26,
                                      height: 26,
                                      imagePath: "assets/images/ic_coin.png"),
                                  MyText(
                                    title: "redeem",
                                    maltilanguage: true,
                                    size: 20,
                                    colors: appDarkColor,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              ),
                            ),
                          ),
                      )
                      : Container(),
                  const SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Subscription()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 49,
                        width: 150,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyImage(
                                width: 26,
                                height: 26,
                                imagePath: "assets/images/ic_coin.png"),
                            MyText(
                              title: "addcoin",
                              maltilanguage: true,
                              size: 20,
                              colors: appDarkColor,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    maltilanguage: false,
                    title: "$strEarnpoint ",
                    size: 20,
                    fontWeight: FontWeight.w600,
                    colors: Colors.white,
                  ),
                  MyText(
                    maltilanguage: true,
                    title: "points",
                    size: 18,
                    fontWeight: FontWeight.w600,
                    colors: Colors.white,
                  ),
                  MyText(
                    maltilanguage: false,
                    title: " = $strEarnamount $strCurrency",
                    size: 18,
                    fontWeight: FontWeight.w600,
                    colors: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    maltilanguage: true,
                    title: "minimum",
                    size: 16,
                    fontWeight: FontWeight.w600,
                    colors: white,
                  ),
                  const SizedBox(width: 2),
                  MyText(
                    maltilanguage: false,
                    title: " $strMinimumpoint ",
                    size: 16,
                    fontWeight: FontWeight.w600,
                    colors: white,
                  ),
                  const SizedBox(width: 2),
                  MyText(
                    maltilanguage: true,
                    title: "pointrequired",
                    size: 16,
                    fontWeight: FontWeight.w600,
                    colors: white,
                  ),
                ],
              ),
            ]),
          );
        }
      },
    );
  }

  buildPager() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: TabBar(
            indicatorColor: appColor,
            labelColor: appColor,
            unselectedLabelColor: appaccentColor,
            tabs: [
              MyText(
                  maltilanguage: true,
                  title: 'coins',
                  size: 13,
                  fontWeight: FontWeight.w600),
              MyText(
                  maltilanguage: true,
                  title: 'reward',
                  size: 13,
                  fontWeight: FontWeight.w600),
              MyText(
                  maltilanguage: true,
                  title: 'Earn',
                  size: 13,
                  fontWeight: FontWeight.w600),
              MyText(
                  maltilanguage: true,
                  title: 'refer',
                  size: 13,
                  fontWeight: FontWeight.w600),
              MyText(
                  maltilanguage: false,
                  title: 'List',
                  size: 13,
                  fontWeight: FontWeight.w600)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    coinsHistory(),
                    rewardHistory(),
                    earnpoint(),
                    referHistory(),
                    withdrawalList()
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  coinsHistory() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, coinsdata, child) {
          if (coinsdata.loading) {
            return walletshimmer();
          } else if (coinsdata.coinsHistoryModel.status == 200 &&
              (coinsdata.coinsHistoryModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              itemCount: coinsdata.coinsHistoryModel.result?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: walletbg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(
                      left: 15, top: 5, right: 15, bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 40,
                              height: 40,
                              imagePath: "assets/images/ic_coin.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coinsdata.coinsHistoryModel.result?[index]
                                      .packageName
                                      .toString() ??
                                  "",
                              style: const TextStyle(
                                  color: white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                MyImage(
                                    width: 12,
                                    height: 12,
                                    imagePath: "assets/images/ic_clock.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyText(
                                  colors: white,
                                  size: 15,
                                  fontWeight: FontWeight.w600,
                                  maltilanguage: false,
                                  title: Utility().dateConvert(
                                      coinsdata.coinsHistoryModel.result?[index]
                                              .createdAt ??
                                          "",
                                      "MMM dd yyyy"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              coinsdata.coinsHistoryModel.result?[index].point
                                      .toString() ??
                                  "",
                              style: GoogleFonts.poppins(
                                  color: yellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            MyText(
                              title: "points",
                              maltilanguage: true,
                              size: 14,
                              fontfamilyInter: false,
                              colors: white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child:MyImage(
                imagePath: "assets/images/nodata.png",
                height: 350,
                width: 350,
              ),
            );
          }
        },
      ),
    );
  }

  rewardHistory() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, rewardpoint, child) {
          if (rewardpoint.loading) {
            return walletshimmer();
          } else if (rewardpoint.rewardModel.status == 200 &&
              (rewardpoint.rewardModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              itemCount: rewardpoint.rewardModel.result?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: walletbg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(
                      left: 15, top: 5, right: 15, bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 40,
                              height: 40,
                              imagePath: "assets/images/ic_coin.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                maltilanguage: false,
                                title: rewardpoint
                                        .rewardModel.result?[index].typename ??
                                    "",
                                size: 18,
                                fontWeight: FontWeight.w600,
                                colors: white),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                MyImage(
                                    width: 12,
                                    height: 12,
                                    imagePath: "assets/images/ic_clock.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyText(
                                    maltilanguage: false,
                                    title: Utility().dateConvert(
                                        rewardpoint.rewardModel.result?[index]
                                                .createdAt ??
                                            "",
                                        "MMM dd yyyy"),
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                    colors: white),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            MyText(
                                maltilanguage: false,
                                title: rewardpoint
                                        .rewardModel.result?[index].rewardPoints
                                        .toString() ??
                                    "",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: yellow),
                            MyText(
                                maltilanguage: true,
                                title: "points",
                                size: 14,
                                fontWeight: FontWeight.w600,
                                colors: white),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child:MyImage(
                imagePath: "assets/images/nodata.png",
                height: 350,
                width: 350,
              ),
            );
          }
        },
      ),
    );
  }

  earnpoint() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, earnpoint, child) {
          if (earnpoint.loading) {
            return walletshimmer();
          } else if (earnpoint.earnModel.status == 200 &&
              (earnpoint.earnModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              itemCount: earnpoint.earnModel.result?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: walletbg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(
                      left: 15, top: 5, right: 15, bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 40,
                              height: 40,
                              imagePath: "assets/images/ic_coin.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              title: earnpoint
                                      .earnModel.result?[index].contestName ??
                                  "",
                              maltilanguage: false,
                              fontWeight: FontWeight.w600,
                              colors: white,
                              size: 18,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                MyImage(
                                    width: 12,
                                    height: 12,
                                    imagePath: "assets/images/ic_clock.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyText(
                                  title: Utility().dateConvert(
                                      earnpoint.earnModel.result?[index]
                                              .createdAt ??
                                          "",
                                      "MMM dd yyyy"),
                                  maltilanguage: false,
                                  fontWeight: FontWeight.w600,
                                  colors: white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            MyText(
                              title: earnpoint.earnModel.result?[index].point ?? "",
                             maltilanguage: false,
                                            size: 16,
                                            fontWeight: FontWeight.w600,colors: yellow,
                            ),
                            MyText(
                              fontWeight: FontWeight.w600,
                              maltilanguage: true,
                              title: "points",
                              colors: white,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child:MyImage(
                imagePath: "assets/images/nodata.png",
                height: 350,
                width: 350,
              ),
            );
          }
        },
      ),
    );
  }

  referHistory() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, referdata, child) {
          if (referdata.loading) {
            return walletshimmer();
          } else if (referdata.referTranModel.status == 200 &&
              (referdata.referTranModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              itemCount: referdata.referTranModel.result?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: walletbg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(
                      left: 15, top: 5, right: 15, bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 40,
                              height: 40,
                              imagePath: "assets/images/ic_coin.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              colors: white,
                              title: referdata
                                      .referTranModel.result?[index].userName
                                      .toString() ??
                                  "",
                              maltilanguage: false,
                              size: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                MyImage(
                                    width: 12,
                                    height: 12,
                                    imagePath: "assets/images/ic_clock.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyText(
                                  colors: white,
                                  title: referdata.referTranModel.result?[index]
                                          .referedDate
                                          .toString() ??
                                      "",
                                  maltilanguage: false,
                                  size: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            MyText(
                              colors: yellow,
                              title: referdata.referTranModel.result?[index]
                                      .referedPoint
                                      .toString() ??
                                  "",
                              maltilanguage: false,
                              size: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            MyText(
                              maltilanguage: true,
                              title: "points",
                              colors: white,
                              size: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child:MyImage(
                imagePath: "assets/images/nodata.png",
                height: 350,
                width: 350,
              ),
            );
          }
        },
      ),
    );
  }

  withdrawalList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Consumer<ApiProvider>(
        builder: (context, withdrawallist, child) {
          if (withdrawallist.loading) {
            return walletshimmer();
          } else if (withdrawallist.withdrawalListModel.status == 200 &&
              (withdrawallist.withdrawalListModel.result?.length ?? 0) > 0) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              itemCount: withdrawallist.withdrawalListModel.result?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: walletbg,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(
                      left: 15, top: 5, right: 15, bottom: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: MyImage(
                              width: 40,
                              height: 40,
                              imagePath: "assets/images/ic_coin.png"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                maltilanguage: false,
                                title: 'Redeem',
                                size: 18,
                                fontWeight: FontWeight.w600,
                                colors: white),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                MyImage(
                                    width: 12,
                                    height: 12,
                                    imagePath: "assets/images/ic_clock.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyText(
                                    maltilanguage: false,
                                    title: Utility().dateConvert(
                                        withdrawallist.withdrawalListModel
                                                .result?[index].createdAt ??
                                            "",
                                        "MMM dd yyyy"),
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                    colors: white),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            MyText(
                                maltilanguage: false,
                                title: withdrawallist.withdrawalListModel
                                        .result?[index].point
                                        .toString() ??
                                    "",
                                size: 16,
                                fontWeight: FontWeight.w600,
                                colors: yellow),
                            MyText(
                                maltilanguage: true,
                                title: "points",
                                size: 14,
                                fontWeight: FontWeight.w600,
                                colors: white),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child:MyImage(
                imagePath: "assets/images/nodata.png",
                height: 350,
                width: 350,
              ),
            );
          }
        },
      ),
    );
  }

  Widget walletshimmer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        );
      },
    );
  }

  Widget pointsshimmer() {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1800),
      baseColor: otpdivider,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
             Container(
                width: 200,
                height: 170,
                decoration: const BoxDecoration(
                    color: appBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
                const SizedBox(
            width: 30,
          ),
              Container(
                width: 100,
                height: 40,
                decoration: const BoxDecoration(
                    color: appBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),

          ]),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
             
              Container(
                width: 190,
                height: 40,
                decoration: const BoxDecoration(
                    color: appBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              const Spacer(),
              Container(
                width: 190,
                height: 40,
                decoration: const BoxDecoration(
                    color: appBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
         Container(
          alignment: Alignment.center,
                width: 100,
                height: 20,
                decoration: const BoxDecoration(
                    color: appBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Container(
              width: 200,
              height: 20,
              decoration: const BoxDecoration(
                  color: appBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ],
      ),
    );
  }
}
