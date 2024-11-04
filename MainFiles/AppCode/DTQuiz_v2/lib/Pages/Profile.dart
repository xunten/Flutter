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
import 'profileupdate.dart';

bool topBar = false;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userId;
  SharePref sharePref = SharePref();

  @override
  initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    userId = Constant.userID;
    debugPrint('userID===>${userId.toString()}');

    if (userId != "" || userId != "0") {
      final profiledata = Provider.of<ApiProvider>(context, listen: false);
      profiledata.getProfile(context, Constant.userID ?? "");
      profiledata.getReferTransaction(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildProfile();
  }

  buildProfile() {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: 400,
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
                buildHeader(),
              ],
            ),
          ]),
          buildData(),
          const SizedBox(
            height: 40,
          ),
          adview()
        ],
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        title: "profile",
        maltilanguage: true,
        size: 20,
        colors: white,
        fontWeight: FontWeight.w400,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileUpdate()));
              },
              child:MyImage(
                imagePath: "assets/images/ic_edit.png",
                width: 20,
              ),
            )),
      ],
    );
  }

  buildHeader() {
    return Consumer<ApiProvider>(
      builder: (context, profiledata, child) {
        if (profiledata.loading) {
          return usershimmer();
        } else {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                (profiledata.profileModel.result?[0].profileImg.toString() ??
                            "")
                        .isNotEmpty
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(profiledata
                                .profileModel.result?[0].profileImg
                                .toString() ??
                            ""))
                    : MyImage(imagePath: 'assets/images/ic_user_default.png',
                        height: 120),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: MyText(
                      maltilanguage: false,
                      title: (profiledata.profileModel.result?[0].fullname
                                      .toString() ??
                                  "")
                              .isNotEmpty
                          ? (profiledata.profileModel.result?[0].fullname
                                  .toString() ??
                              "")
                          : profiledata.profileModel.result?[0].email
                              .toString(),
                      size: 22,
                      fontWeight: FontWeight.w500,
                      colors: Colors.white,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                          minRadius: 15,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage("assets/images/ic_icons.png")),
                    ),
                    const SizedBox(width: 5),
                    MyText(title: "Gold",
                       maltilanguage: false,colors: white,
                                            size: 18,
                                            fontWeight: FontWeight.w500,),
                  ],
                ),
                const SizedBox(height: 20),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: [
                          MyText(
                              title: profiledata.profileModel.result?[0].totalScore
                                      .toString() ??
                                  "",
                                  colors: white,
                            maltilanguage: false,
                                            size: 18,
                                            fontWeight: FontWeight.w500,),
                          MyText(
                            title: "quizplay",
                            maltilanguage: true,
                            fontfamilyInter: false,
                            size: 18,
                            fontWeight: FontWeight.w500,
                            colors: Colors.white,
                          ),
                        ],
                      ),
                      const Spacer(),
                      const VerticalDivider(
                        color: white,
                        thickness: 0.5,
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          MyText(
                              title: profiledata.profileModel.result?[0].totalPoints
                                      .toString() ??
                                  "",
                                  colors: white,
                             maltilanguage: false,
                                            size: 18,
                                            fontWeight: FontWeight.w500,),
                          MyText(
                            title: "pointeard",
                            colors: Colors.white,
                            size: 18,
                            fontWeight: FontWeight.w500,
                            fontfamilyInter: false,
                            maltilanguage: true,
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                )
              ]);
        }
      },
    );
  }

  buildData() {
    return Consumer<ApiProvider>(
      builder: (context, profiledata, child) {
        if (profiledata.loading) {
          return profiledetailsshimmer();
        } else {
          return Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const CircleAvatar(
                      minRadius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/ic_mail.png")),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: "email",
                        maltilanguage: true,
                        fontfamilyInter: false,
                        fontWeight: FontWeight.w400,
                        colors: textColorGrey,
                      ),
                      MyText(
                        maltilanguage: false,
                        title: profiledata.profileModel.result?[0].email
                                .toString() ??
                            "",
                        size: 16,
                        fontWeight: FontWeight.w500,
                        colors: black,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const CircleAvatar(
                      minRadius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("assets/images/ic_mobile.png")),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: "contectno",
                        maltilanguage: true,
                        fontfamilyInter: false,
                        fontWeight: FontWeight.w400,
                        colors: textColorGrey,
                      ),
                      MyText(
                        maltilanguage: false,
                        title: profiledata.profileModel.result?[0].mobileNumber
                                .toString() ??
                            "",
                        size: 16,
                        fontWeight: FontWeight.w500,
                        colors: black,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const CircleAvatar(
                      minRadius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("assets/images/ic_location.png")),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: "address",
                        maltilanguage: false,
                        fontfamilyInter: false,
                        fontWeight: FontWeight.w400,
                        colors: textColorGrey,
                      ),
                      MyText(
                        maltilanguage: false,
                        title: (profiledata.profileModel.result?[0].biodata
                                .toString() ??
                            ""),
                        size: 16,
                        fontWeight: FontWeight.w500,
                        colors: black,
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget profiledetailsshimmer() {
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
}
