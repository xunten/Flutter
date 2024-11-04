import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/quiz/questions.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

class Level extends StatefulWidget {
  final String catId;
  const Level({
    Key? key,
    required this.catId,
  }) : super(key: key);

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {
  SharePref sharePref = SharePref();
  String? userId;

  @override
  initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    userId = Constant.userID;
    debugPrint('userID===>${userId.toString()}');
    final leveldata = Provider.of<ApiProvider>(context, listen: false);
    leveldata.getLevel(context, widget.catId, Constant.userID ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.elliptical(50.0, 50.0)),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: MyAppbar(
              title: "selectlevel",
            ),
          ),
          body: Stack(
            children: [
              buildBody(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    color: Colors.transparent,
                    height: 60,
                    child: AdHelper().bannerAd(),
                  ),
                ),
              )
            ],
          )),
    );
  }

  getAppbar() {
    return AppBar(
      title: MyText(
        maltilanguage: true,
        title: "selectlevel",
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
    return Column(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Consumer<ApiProvider>(
              builder: (context, leveldata, child) {
                if (leveldata.loading) {
                  return levelshimmer();
                } else if (leveldata.levelModel.status == 200 &&
                    (leveldata.levelModel.result?.length ?? 0) > 0) {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: leveldata.levelModel.result?.length ?? 0,
                    itemBuilder: (BuildContext ctx, index) {
                      log("level${leveldata.levelModel.result?[index].totalQuestion.toString()}");
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Questions(
                                        type: 1,
                                        catId: widget.catId,
                                        levelId: leveldata
                                                .levelModel.result?[index].id
                                                .toString() ??
                                            "",
                                        levelname: leveldata
                                            .levelModel.result?[index].name,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5, top: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyImage(
                                    width: 80,
                                    height: 80,
                                    imagePath: 'assets/images/level_lock.png'),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyText(
                                    maltilanguage: false,
                                    title: leveldata
                                            .levelModel.result?[index].name ??
                                        "",
                                    size: 16,
                                    fontWeight: FontWeight.w500,
                                    colors: textColor),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MyText(
                                        title: "questions",
                                        maltilanguage: true,
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                        colors: textColor),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    MyText(
                                        maltilanguage: false,
                                        title: leveldata.levelModel
                                                .result?[index].totalQuestion
                                                .toString() ??
                                            "",
                                        size: 14,
                                        fontWeight: FontWeight.w500,
                                        colors: textColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return MyImage(
                    imagePath: "assets/images/nodata.png",
                    height: 250,
                    width: 250,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget levelshimmer() {
    return SingleChildScrollView(
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 8,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
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
}
