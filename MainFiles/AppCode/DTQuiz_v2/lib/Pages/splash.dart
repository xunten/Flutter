// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/Home.dart';
import 'package:quizapp/Pages/login/login.dart';
import 'package:quizapp/Pages/onboaring.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/myimage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  String? seen;
  int? index;
  SharePref sharePref = SharePref();
  // ignore: prefer_typing_uninitialized_variables
  @override
  initState() {
    getGeneral();
    AdHelper.getAds();
    super.initState();
  }

  getGeneral() async {
    final bannerdata = Provider.of<ApiProvider>(context, listen: false);
    log("Generat setting api calling");
    await bannerdata.getGeneralsetting(context);
    if (!bannerdata.loading) {
      for (var i = 0; i < bannerdata.generalSettingModel.result!.length; i++) {
        debugPrint(
            '===>${bannerdata.generalSettingModel.result?[i].key} ===> ${bannerdata.generalSettingModel.result?[i].value}');
        await sharePref.save(
            bannerdata.generalSettingModel.result?[i].key ?? "",
            bannerdata.generalSettingModel.result?[i].value ?? "");
      }
      idFirstChack();
    }
    log("Generat setting api calling complete");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: MyImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
            imagePath: "assets/images/splash.png"),
      ),
    );
  }

  idFirstChack() async {
    Constant.userID = await sharePref.read('userId');
    seen = await sharePref.read('seen') ?? "0";
    String isLogin = await sharePref.read('is_login') ?? "0";
    debugPrint('===>$seen');
    if (seen == "1") {
      if (isLogin == "1") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Home();
            },
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Login();
            },
          ),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const OnBoardingPage();
          },
        ),
      );
    }
  }
}
