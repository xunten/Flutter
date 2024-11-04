// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/commonpage.dart';
import 'package:quizapp/Pages/Share.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = true;

  @override
  void initState() {
    getApi();
    super.initState();
  }

  getApi() async {
    log("calling getpages api ");
    final pageprovider = Provider.of<ApiProvider>(context, listen: false);
    await pageprovider.getPages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: getAppbar(),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [const SizedBox(height: 30), buildBody()],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: adview(),
          )
        ],),
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        title: "settings",
        maltilanguage: true,
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
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          pages(),
          menuItem("pushnotification"),
          InkWell(
            onTap: () {
              languageBottomSheet();
            },
            child: menuItem("applanguage"),
          ),
          // menuItem("Enable Sound"),
          InkWell(
            onTap: () {
              log("share button clicked");
              AdHelper.showInterstitialAd();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Share()));
            },
            child: menuItem("shareapp"),
          ),
          menuItem("rateapp"),
        ]),
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

  Widget menuItem(String title) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              MyText(
                  maltilanguage: true,
                  title: title,
                  size: 14,
                  fontWeight: FontWeight.w600),
              const Spacer(),
              if (title == 'Push Notification' ||
                  title == 'Enable Sound' ||
                  title == 'Enable Vibration')
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                )
              else
               MyImage(imagePath: "assets/images/ic_right_arrow.png", height: 15),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 0.5, color: textColorGrey),
        ],
      ),
    );
  }

  Widget pages() {
    return Consumer<ApiProvider>(builder: (context, pages, child) {
      if (pages.loading) {
        return Container();
      } else if (pages.pagesModel.status == 200 &&
          (pages.pagesModel.result?.length ?? 0) > 0) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: pages.pagesModel.result?.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    AdHelper.showInterstitialAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommonPage(
                                  url: pages.pagesModel.result?[index].url
                                          .toString() ??
                                      "",
                                  title: pages
                                          .pagesModel.result?[index].pageName
                                          .toString() ??
                                      "",
                                )));
                  },
                  child: Row(
                    children: [
                      MyText(
                          maltilanguage: true,
                          title: pages.pagesModel.result?[index].pageName,
                          size: 15,
                          fontWeight: FontWeight.w600),
                      const Spacer(),
                     MyImage(imagePath: "assets/images/ic_right_arrow.png",
                          height: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 0.5, color: textColorGrey),
              ],
            );
          },
        );
      } else {
        return Container();
      }
    });
  }

  languageBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: white,
      builder: (BuildContext context) {
        return BottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: white,
                  child: Column(
                    children: [
                      ListTile(
                        title:  MyText(title: "Englist",maltilanguage: false,),
                        onTap: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('en');
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title:  MyText(title: "हिन्दी",maltilanguage: false,),
                        onTap: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('hi');
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        title:  MyText(title: "Arebic",maltilanguage: false,),
                        onTap: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('ar');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
