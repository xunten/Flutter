import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

import 'pratisecategory.dart';

class PraticeStage extends StatefulWidget {
  const PraticeStage({Key? key}) : super(key: key);

  @override
  State<PraticeStage> createState() => _PraticeStageState();
}

class _PraticeStageState extends State<PraticeStage> {
  @override
  void initState() {
    super.initState();
    final levelmaster = Provider.of<ApiProvider>(context, listen: false);
    levelmaster.getLevelMaster();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: MyAppbar(
            title: "practisewith",
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  getAppbar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: MyAppbar(
        title: "Practise With",
      ),
    );
  }

  buildBody() {
    return Column(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 7,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login_bg_white.png"),
                    fit: BoxFit.fill)),
            child: Consumer<ApiProvider>(
              builder: (context, levelmasterdata, child) {
                if (levelmasterdata.loading) {
                  return levelmastershimmer();
                } else if (levelmasterdata.levelMasterModel.status == 200 &&
                    (levelmasterdata.levelMasterModel.result?.length ?? 0) >
                        0) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount:
                        levelmasterdata.levelMasterModel.result?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PratiseCategory(
                                        type: "practise",
                                        masterId: levelmasterdata
                                                .levelMasterModel
                                                .result?[index]
                                                .id
                                                .toString() ??
                                            "",
                                      )));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 80,
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      primary,
                                      primary,
                                    ],
                                  )),
                              child: Center(
                                child: MyText(
                                  maltilanguage: false,
                                  title: levelmasterdata.levelMasterModel
                                          .result?[index].levelName ??
                                      "",
                                  size: 22,
                                  textalign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  colors: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: MyImage(
                      imagePath: "assets/images/nodata.png",
                      height: 250,
                      width: 250,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Colors.transparent,
              height: 60,
              child: AdHelper().bannerAd(),
            ),
          ),
        ),
      ],
    );
  }

  Widget levelmastershimmer() {
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
            height: 20,
          );
        },
      ),
    );
  }
}
