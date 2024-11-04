import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Profile.dart';
import 'package:quizapp/Pages/Settings.dart';
import 'package:quizapp/Pages/Wallet.dart';
import 'package:quizapp/Pages/instrucation.dart';
import 'package:quizapp/Pages/leaderboard.dart';
import 'package:quizapp/Pages/login/login.dart';
import 'package:quizapp/Pages/notification.dart';
import 'package:quizapp/Pages/quiz/audiovideocategory.dart';
import 'package:quizapp/Pages/quiz/questions.dart';
import 'package:quizapp/Pages/referearn.dart';
import 'package:quizapp/Pages/spinwheel.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';
import 'contest/contest.dart';
import 'pratise/praticestage.dart';
import 'quiz/category.dart';

bool topBar = false;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharePref sharePref = SharePref();
  String? userId;
  int selectedIndex = 0;
  var androidBannerAdsId = "";
  var iosBannerAdsId = "";
  var bannerad = "";
  var banneradIos = "";

  @override
  initState() {
    log("User ID Is == ${Constant.userID}");
    userId = Constant.userID ?? "";
    debugPrint('userID===>${userId.toString()}');
    Utility.getCurrencySymbol();

    getLogin();

    getId();
    super.initState();
  }

  getId() async {
    androidBannerAdsId = await sharePref.read("banner_adid") ?? "";
    iosBannerAdsId = await sharePref.read("ios_banner_adid") ?? "";
    bannerad = await sharePref.read("banner_ad") ?? "";
    banneradIos = await sharePref.read("ios_banner_ad") ?? "";

    debugPrint("Android id:====$bannerad");
    debugPrint("ios id:====$banneradIos");
  }

  getLogin() async {
    final profiledata = Provider.of<ApiProvider>(context, listen: false);
    await profiledata.getProfile(context, Constant.userID ?? "");
    String isLogin = await sharePref.read('is_login') ?? "0";
    debugPrint('===>$isLogin');
    if (userId != "" || userId != null) {}

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {});
    _googleSignIn.signInSilently();

    AdHelper.createInterstitialAd();
    AdHelper.createRewardedAd();
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: GestureDetector(
        onTap: () {
          topBar = false;
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 310,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getAppbar(), buildBody()],
              ),
              topBar ? getTopBar() : Container(),
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
        title: "dtquize",
        size: 20,
        colors: Colors.white,
      ),
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: GestureDetector(
          child: MyImage(
            imagePath: 'assets/images/ic_home.png',
            width: 50,
            height: 50,
          ),
          onTap: () {
            debugPrint("Home click");
            setState(() {
              topBar = true;
            });
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: GestureDetector(
            child: MyImage(
              imagePath: 'assets/images/ic_bell.png',
              width: 40,
            ),
            onTap: () {
              debugPrint("Bell Click");
              AdHelper.showInterstitialAd();
              if (Constant.userID == null || Constant.userID == "") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()));
              }
            },
          ),
        ),
      ],
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 5),
            child: LocaleText(
              "welcomeback",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          Constant.userID != null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 5),
                  child: Consumer<ApiProvider>(
                    builder: (context, profiledata, child) {
                      if (profiledata.loading) {
                        return Container();
                      } else {
                        String? email = profiledata
                                .profileModel.result?[0].email
                                .toString() ??
                            "";
                        String? mobile = profiledata
                                .profileModel.result?[0].mobileNumber
                                .toString() ??
                            "";

                        return MyText(
                          title: email.isNotEmpty ? email : mobile,
                          maltilanguage: false,
                          colors: white,
                          size: 24,
                          fontWeight: FontWeight.w600,
                        );
                      }
                    },
                  ),
                )
              : MyText(
                  title: "Guest User",
                  maltilanguage: false,
                  colors: white,
                  size: 24,
                  fontWeight: FontWeight.w500,
                ),
          const SizedBox(
            height: 10,
          ),
          getDashboard(),
          const SizedBox(
            height: 10,
          ),
          getBottom(),
        ]),
      ),
    );
  }

  getTopBar() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: textBoxColor,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.elliptical(30.0, 30.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (Constant.userID == null || Constant.userID == "") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  } else {
                    // AdHelper.showFullscreenAd(context, Constant.rewardAdType,
                    //     () {
                    //   log("Navigate to anther screen ");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpinWheel()));
                  }
                  // );
                  // }
                },
                child: Column(
                  children: [
                    MyImage(
                      width: 60,
                      imagePath: 'assets/images/ic_spinwin.png',
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyText(
                      title: "spinwin",
                      maltilanguage: true,
                      fontfamilyInter: false,
                      colors: textColor,
                      size: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.grey,
                height: 0.3,
                width: 100,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  if (Constant.userID == null || Constant.userID == "") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Wallet()));
                    topBar = false;
                    setState(() {});
                  }
                },
                child: Column(
                  children: [
                    MyImage(
                      width: 60,
                      imagePath: 'assets/images/ic_spin.png',
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyText(
                      title: "wallet",
                      maltilanguage: true,
                      fontfamilyInter: false,
                      colors: textColor,
                      size: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
            ],
          )),
          Container(
            color: Colors.grey,
            width: 0.3,
            height: 150,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  AdHelper.showInterstitialAd();

                  if (Constant.userID == null || Constant.userID == "") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReferEarn()));
                    topBar = false;
                    setState(() {});
                  }
                },
                child: Column(
                  children: [
                    MyImage(
                      width: 60,
                      imagePath: 'assets/images/ic_referearn.png',
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyText(
                      title: "referearn",
                      maltilanguage: true,
                      fontfamilyInter: false,
                      fontWeight: FontWeight.w500,
                      colors: textColor,
                      size: 16,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.grey,
                height: 0.3,
                width: 100,
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  AdHelper.showInterstitialAd();
                  await Utility.setUserId(null);
                  _handleSignOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const Login()),
                      ModalRoute.withName('/'));
                  topBar = false;
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyImage(
                      imagePath: 'assets/images/ic_logout.png',
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyText(
                      title: Constant.userID == null ? "login" : "logout",
                      maltilanguage: true,
                      size: 16,
                      colors: textColor,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
            ],
          )),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  getDashboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Contest()));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/red_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          maltilanguage: true,
                          title: "contest",
                          size: 26,
                          fontfamilyInter: false,
                          fontWeight: FontWeight.w600,
                          colors: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 40.0,
                            width: 55.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PraticeStage()));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/blue_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          maltilanguage: true,
                          title: "practise",
                          fontfamilyInter: false,
                          size: 26,
                          colors: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 35.0,
                            width: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Category()));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/yellow_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          title: "quiz",
                          maltilanguage: true,
                          size: 28,
                          fontWeight: FontWeight.bold,
                          colors: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 35.0,
                            width: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AudioVideoCategory(
                                type: 2,
                              )));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/green_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          colors: white,
                          maltilanguage: true,
                          size: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        MyText(
                          title: "audio",
                          colors: white,
                          maltilanguage: true,
                          size: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 40.0,
                            width: 55.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AudioVideoCategory(
                                type: 3,
                              )));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/red_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          title: "video",
                          maltilanguage: true,
                          size: 28,
                          fontWeight: FontWeight.bold,
                          colors: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 35.0,
                            width: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  AdHelper.showInterstitialAd();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AudioVideoCategory(
                                type: 4,
                              )));
                  topBar = false;
                  setState(() {});
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/yellow_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          title: "true/false",
                          maltilanguage: true,
                          size: 26,
                          fontWeight: FontWeight.bold,
                          colors: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 40.0,
                            width: 55.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  // AdHelper.showFullscreenAd(
                  //   context,
                  //   Constant.rewardAdType,
                  //   () {
                  log("Navigate to anther screen ");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Questions(
                                type: 5,
                              )));
                  topBar = false;
                  //   },
                  // );
                },
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/green_bg.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          title: "joinin",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          colors: Colors.white,
                          size: 18,
                        ),
                        MyText(
                          title: "dailyquiz",
                          maltilanguage: true,
                          size: 28,
                          fontWeight: FontWeight.bold,
                          colors: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: MyImage(
                            imagePath: 'assets/images/right_arrow.png',
                            height: 35.0,
                            width: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }

  getBottom() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox(
              height: 60,
              child: AdHelper().bannerAd(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 40),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              const SizedBox(width: 10),
              MyText(
                title: "other",
                size: 19,
                colors: textColor,
                fontWeight: FontWeight.w600,
                maltilanguage: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: 70,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      AdHelper.showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoard()));
                      topBar = false;
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        MyImage(
                          imagePath: 'assets/images/ic_leadericon.png',
                          height: 60,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                          title: "leaderboard",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          size: 16,
                          colors: textColor,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.3,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Constant.userID == null || Constant.userID == "") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      } else {
                        AdHelper.showInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      }
                      topBar = false;
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        MyImage(
                          imagePath: 'assets/images/ic_pfofileicon.png',
                          height: 60,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                          title: "profile",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          size: 16,
                          colors: textColor,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ],
              )),
              Container(
                color: Colors.grey,
                width: 0.3,
                height: 150,
              ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      AdHelper.showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Instrucation()));
                      topBar = false;
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                          imagePath: 'assets/images/ic_instruction.png',
                          height: 60,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                          title: "instruction",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          size: 16,
                          colors: textColor,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.3,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AdHelper.showInterstitialAd();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()));
                      topBar = false;
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                          imagePath: 'assets/images/ic_settings.png',
                          height: 60,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyText(
                          title: "setting",
                          maltilanguage: true,
                          fontfamilyInter: false,
                          size: 16,
                          colors: textColor,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                ],
              )),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  navigate() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SpinWheel()));
  }
}
