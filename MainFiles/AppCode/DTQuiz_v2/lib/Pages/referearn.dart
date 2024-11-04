import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';

import '../widget/mytext.dart';

bool topBar = false;

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  SharePref sharePref = SharePref();
  String? reference;

  @override
  void initState() {
    getSharedPre();
    super.initState();
  }

  getSharedPre() async {
    reference = await sharePref.read('reference') ?? "";
    debugPrint('reference===>${reference.toString()}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return buildViewPager();
  }

  buildViewPager() {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: 430,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getAppbar(),
                buildBody(),
              ],
            ),
          ]),
          buildShareIcon(),
          adview()
        ],
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(title: "shareapp");
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

  buildBody() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 20),
      MyImage(imagePath: 'assets/images/ic_share.png', height: 90),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Center(
          child: MyText(
            maltilanguage: true,
            fontfamilyInter: false,
            textalign: TextAlign.center,
            size: 16,
            colors: Colors.white,
            fontWeight: FontWeight.normal,
            title: "sharetext",
          ),
        ),
      ),
      const SizedBox(height: 30),
      DottedBorder(
        dashPattern: const [4, 4],
        strokeWidth: 1,
        color: white,
        child: Container(
          height: 50,
          width: 250,
          color: tabbarunselect,
          child: Center(
            child: MyText(
              maltilanguage: false,
              title: reference ?? "",
              size: 24,
              fontWeight: FontWeight.w600,
              colors: white,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: MyText(
          title: "copycode",
          size: 16,
          fontWeight: FontWeight.normal,
          colors: white,
          maltilanguage: true,
          fontfamilyInter: false,
        ),
      ),
    ]);
  }

  buildShareIcon() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
              maltilanguage: true,
              title: "sharefriend",
              size: 18,
              fontWeight: FontWeight.w500),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_fb.png"),
                  const SizedBox(height: 5),
                  MyText(
                      maltilanguage: true,
                      title: "fb",
                      size: 14,
                      fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_tw.png"),
                  const SizedBox(height: 5),
                  MyText(
                      maltilanguage: true,
                      title: "twitter",
                      size: 14,
                      fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_gp.png"),
                  const SizedBox(height: 5),
                  MyText(
                      maltilanguage: true,
                      title: "google",
                      size: 14,
                      fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_line.png"),
                  const SizedBox(height: 5),
                  MyText(
                      maltilanguage: true,
                      title: "line",
                      size: 14,
                      fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_wp.png"),
                  const SizedBox(height: 5),
                  MyText(
                      maltilanguage: true,
                      title: "whatsapp",
                      size: 14,
                      fontWeight: FontWeight.w500)
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MyImage(
                      width: 50,
                      height: 50,
                      imagePath: "assets/images/ic_sms.png"),
                  const SizedBox(height: 5),
                  MyText(
                    title: "sms",
                    size: 14,
                    fontWeight: FontWeight.w500,
                    maltilanguage: true,
                  )
                ],
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
