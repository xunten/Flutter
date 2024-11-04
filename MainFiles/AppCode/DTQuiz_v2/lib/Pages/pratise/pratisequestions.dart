import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/Utility.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/provider/commanprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/mynetimage.dart';
import 'package:quizapp/widget/mytext.dart';

import 'praticelevelresult.dart';

class PratiseQuestions extends StatefulWidget {
  final String? catId, levelId, levelname, levelMasterId;
  const PratiseQuestions(
      {Key? key,
      required this.catId,
      required this.levelId,
      required this.levelname,
      required this.levelMasterId})
      : super(key: key);

  @override
  State<PratiseQuestions> createState() => _PratiseQuestionsState();
}

class _PratiseQuestionsState extends State<PratiseQuestions> {
  SharePref sharePref = SharePref();
  late ApiProvider questiondata;
  String? userId;

  final playerC = AudioPlayer();
  final playerW = AudioPlayer();

  double percent = 0.0;
  Timer? timer;

  int answercnt = 1;
  int selectAnswer = -1;

  @override
  void initState() {
    log("userid is === >> ${Constant.userID}");
    log("master level id is === >> ${widget.levelMasterId}");
    super.initState();
    getUserId();
  }

  getUserId() async {
    questiondata = Provider.of<ApiProvider>(context, listen: false);
    await questiondata.getQuestionByLevelPratice(widget.catId,
        widget.levelId.toString(), widget.levelMasterId.toString());
    AdHelper.createInterstitialAd();
    AdHelper.createRewardedAd();
  }

  playSound(int pos) async {
    await playerC.setUrl('asset:assets/audio/correct.mp3');
    await playerW.setUrl('asset:assets/audio/wrong.mp3');
    if (playerC.playing) {
      await playerC.stop();
    }
    if (playerW.playing) {
      await playerW.stop();
    }
    if (pos == 1) {
      await playerC.play();
    } else {
      await playerW.play();
    }
  }

  @override
  void dispose() {
    log("clear the provider");
    questiondata.clearprovider();
    super.dispose();
  }

  getAnswer(int qindex, index) {
    if (index == 0) {
      return 'A. ${questiondata.questionPraticeModel.result?[qindex].optionA ?? ""}';
    } else if (index == 1) {
      return 'B. ${questiondata.questionPraticeModel.result?[qindex].optionB ?? ""}';
    } else if (index == 2) {
      return 'C. ${questiondata.questionPraticeModel.result?[qindex].optionC ?? ""}';
    } else {
      return 'D. ${questiondata.questionPraticeModel.result?[qindex].optionD ?? ""}';
    }
  }

  double cntvalue = 0;

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: Center(
              child: MyText(
                maltilanguage: false,
                title: widget.levelname.toString(),
                size: 18,
                fontWeight: FontWeight.w400,
                colors: white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    child: Center(
                      child: Consumer<ApiProvider>(
                        builder: (context, questiondata, child) {
                          return MyText(
                              maltilanguage: false,
                              title:
                                  '${((questiondata.selectQuestion ?? 0) + 1)} / ${questiondata.questionPraticeModel.result?.length ?? 0}',
                              size: 18,
                              fontWeight: FontWeight.w400,
                              colors: white);
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login_bg_white.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Consumer<ApiProvider>(
                    builder: (context, questiondata, child) {
                      if (!questiondata.loading) {
                        debugPrint('questiondata===>$questiondata');

                        debugPrint(questiondata
                            .questionPraticeModel.result?.length
                            .toString());
                        if (questiondata.questionPraticeModel.result?.length
                                .toInt() ==
                            0) {
                          Utility.toastMessage("There are no any Questions");
                          Timer(const Duration(seconds: 3), () {
                            Navigator.of(context).pop();
                          });
                        }
                      }
                      return questiondata.loading
                          ? Center(
                              child: usershimmer(),
                            )
                          : questiondata.questionPraticeModel.result?.length
                                      .toInt() !=
                                  0
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        color: Colors.transparent,
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Positioned(
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: primary,
                                                        width: 4),
                                                    color: white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                                child: CircularPercentIndicator(
                                                  radius: 30.0,
                                                  lineWidth: 4.0,
                                                  animation: false,
                                                  percent: percent / 100,
                                                  center: MyText(
                                                    title: percent
                                                        .toInt()
                                                        .toString(),
                                                    maltilanguage: false,
                                                    size: 20,
                                                    fontWeight: FontWeight.w600,
                                                    colors: black,
                                                  ),
                                                  backgroundColor: Colors.grey,
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor:
                                                      Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30, right: 30),
                                                child: Consumer<CommanProvider>(
                                                  builder: (context,
                                                      commandProvider, child) {
                                                    return Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            MyText(
                                                                maltilanguage:
                                                                    false,
                                                                title: commandProvider
                                                                    .correctanswer
                                                                    .toString()),
                                                            LinearPercentIndicator(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              animation: false,
                                                              lineHeight: 3.0,
                                                              percent:
                                                                  (commandProvider
                                                                          .correctPercent /
                                                                      100),
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(20),
                                                              progressColor: Colors
                                                                  .greenAccent,
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            LinearPercentIndicator(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                              animation: false,
                                                              lineHeight: 3.0,
                                                              percent:
                                                                  (commandProvider
                                                                          .incorrectPercent /
                                                                      100),
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(20),
                                                              progressColor:
                                                                  Colors.red,
                                                            ),
                                                            MyText(
                                                                maltilanguage:
                                                                    false,
                                                                title: commandProvider
                                                                    .inCorrectanswer
                                                                    .toString()),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      MyText(
                                        maltilanguage: true,
                                        title: "bollywood",
                                        fontWeight: FontWeight.w500,
                                        size: 16,
                                        colors: textColorGrey,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      (questiondata
                                                      .questionPraticeModel
                                                      .result?[questiondata
                                                              .selectQuestion ??
                                                          0]
                                                      .image
                                                      ?.length ??
                                                  0) >
                                              0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  MyNetImage(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25,
                                                      fit: BoxFit.fill,
                                                      imagePath: questiondata
                                                              .questionPraticeModel
                                                              .result?[questiondata
                                                                      .selectQuestion ??
                                                                  0]
                                                              .image
                                                              .toString() ??
                                                          ""),
                                                  const SizedBox(height: 5),
                                                  AutoSizeText(
                                                    questiondata
                                                            .questionPraticeModel
                                                            .result?[questiondata
                                                                    .selectQuestion ??
                                                                0]
                                                            .question
                                                            .toString() ??
                                                        "",
                                                    style: GoogleFonts.inter(
                                                        fontSize: 16,
                                                        color: textColorGrey,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    minFontSize: 12,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ))
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.18,
                                              child: Center(
                                                child: AutoSizeText(
                                                  questiondata
                                                          .questionPraticeModel
                                                          .result?[questiondata
                                                                  .selectQuestion ??
                                                              0]
                                                          .question
                                                          .toString() ??
                                                      "",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 22,
                                                      color: textColorGrey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  minFontSize: 12,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 6,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                      const SizedBox(height: 23),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: (questiondata
                                                              .questionPraticeModel
                                                              .result?[questiondata
                                                                      .selectQuestion ??
                                                                  0]
                                                              .image
                                                              ?.length ??
                                                          0) >
                                                      0
                                                  ? 2
                                                  : 1,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: (questiondata
                                                              .questionPraticeModel
                                                              .result?[questiondata
                                                                      .selectQuestion ??
                                                                  0]
                                                              .image
                                                              ?.length ??
                                                          0) >
                                                      0
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          7)
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          14),
                                            ),
                                            itemCount: 4,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Consumer<CommanProvider>(
                                                builder:
                                                    (context, answer, child) {
                                                  debugPrint(
                                                      'select Answer===>${answer.selectAnswer}');
                                                  debugPrint(
                                                      'correct Answer===>${answer.correctAns}');
                                                  debugPrint('index===>$index');
                                                  return InkWell(
                                                    onTap: () {
                                                      Provider.of<CommanProvider>(
                                                              context,
                                                              listen: false)
                                                          .answerclick(index);
                                                    },
                                                    child: answer
                                                                .selectAnswer ==
                                                            index
                                                        ? answer.correctAns ==
                                                                (index + 1)
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            green,
                                                                        width:
                                                                            0.4),
                                                                    color:
                                                                        green,
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            25))),
                                                                child:
                                                                    AutoSizeText(
                                                                  getAnswer(
                                                                      (questiondata
                                                                              .selectQuestion ??
                                                                          0),
                                                                      index),
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  minFontSize:
                                                                      10,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                            : Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            inActiveColor,
                                                                        width:
                                                                            0.4),
                                                                    color:
                                                                        inActiveColor,
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            25))),
                                                                child:
                                                                    AutoSizeText(
                                                                  getAnswer(
                                                                      (questiondata
                                                                              .selectQuestion ??
                                                                          0),
                                                                      index),
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  minFontSize:
                                                                      10,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                        : answer.correctAns ==
                                                                (index + 1)
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            green,
                                                                        width:
                                                                            0.4),
                                                                    color:
                                                                        green,
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            25))),
                                                                child:
                                                                    AutoSizeText(
                                                                  getAnswer(
                                                                      (questiondata
                                                                              .selectQuestion ??
                                                                          0),
                                                                      index),
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          18,
                                                                      color:
                                                                          white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  minFontSize:
                                                                      10,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )
                                                            : Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            textColorGrey,
                                                                        width:
                                                                            0.4),
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            25))),
                                                                child:
                                                                    AutoSizeText(
                                                                  getAnswer(
                                                                      (questiondata
                                                                              .selectQuestion ??
                                                                          0),
                                                                      index),
                                                                  style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          16,
                                                                      color:
                                                                          black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                  minFontSize:
                                                                      10,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                  );
                                                },
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                height: 50,
                                                child: TextButton(
                                                    onPressed: () {
                                                      int selectAnswer =
                                                          Provider.of<CommanProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .selectAnswer ??
                                                              0;

                                                      if ((selectAnswer + 1)
                                                              .toString() ==
                                                          questiondata
                                                              .questionPraticeModel
                                                              .result?[questiondata
                                                                      .selectQuestion ??
                                                                  0]
                                                              .answer) {
                                                        log('Correct');
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .correctAnswer(
                                                                1,
                                                                questiondata
                                                                        .questionPraticeModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionPraticeModel
                                                                        .result?[
                                                                            questiondata.selectQuestion ??
                                                                                0]
                                                                        .answer ??
                                                                    ""));

                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .corAns(int.parse(questiondata
                                                                    .questionPraticeModel
                                                                    .result?[
                                                                        questiondata.selectQuestion ??
                                                                            0]
                                                                    .answer ??
                                                                ""));
                                                        playSound(1);
                                                      } else {
                                                        log('InCorrect');
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .inCorrectAnswer(
                                                                1,
                                                                questiondata
                                                                        .questionPraticeModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionPraticeModel
                                                                        .result?[
                                                                            questiondata.selectQuestion ??
                                                                                0]
                                                                        .answer ??
                                                                    ""));
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .corAns(int.parse(questiondata
                                                                    .questionPraticeModel
                                                                    .result?[
                                                                        questiondata.selectQuestion ??
                                                                            0]
                                                                    .answer ??
                                                                ""));

                                                        playSound(0);
                                                      }
                                                      if ((questiondata
                                                                  .selectQuestion ??
                                                              0) <
                                                          (questiondata
                                                                      .questionPraticeModel
                                                                      .result
                                                                      ?.length ??
                                                                  0) -
                                                              1) {
                                                        Timer(
                                                            const Duration(
                                                                seconds: 5),
                                                            () {
                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .answerclick(-1);
                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .corAns(-1);
                                                          Provider.of<ApiProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changeQuestion(
                                                                  (questiondata
                                                                              .selectQuestion ??
                                                                          0) +
                                                                      1);
                                                        });
                                                      } else {
                                                        Timer(
                                                            const Duration(
                                                                seconds: 0),
                                                            () {
                                                          saveQuestionReport();
                                                          Provider.of<ApiProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changeQuestion(
                                                                  0);

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .correctAnswer(
                                                                  0,
                                                                  questiondata
                                                                          .questionPraticeModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionPraticeModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .inCorrectAnswer(
                                                                  0,
                                                                  questiondata
                                                                          .questionPraticeModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionPraticeModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .answerclick(-1);

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .corAns(-1);
                                                        });
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(primary),
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                                side: const BorderSide(
                                                                    color:
                                                                        primary)))),
                                                    child: MyText(
                                                      maltilanguage: true,
                                                      title: "answerit",
                                                      colors: white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      size: 16,
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                height: 50,
                                                child: TextButton(
                                                    onPressed: () {
                                                      int selectAnswer =
                                                          Provider.of<CommanProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .selectAnswer ??
                                                              0;

                                                      if ((selectAnswer + 1)
                                                              .toString() ==
                                                          questiondata
                                                              .questionPraticeModel
                                                              .result?[questiondata
                                                                      .selectQuestion ??
                                                                  0]
                                                              .answer) {
                                                        log('Correct');
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .correctAnswer(
                                                                1,
                                                                questiondata
                                                                        .questionPraticeModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionPraticeModel
                                                                        .result?[
                                                                            questiondata.selectQuestion ??
                                                                                0]
                                                                        .answer ??
                                                                    ""));
                                                      } else {
                                                        log('InCorrect');
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .inCorrectAnswer(
                                                                1,
                                                                questiondata
                                                                        .questionPraticeModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionPraticeModel
                                                                        .result?[
                                                                            questiondata.selectQuestion ??
                                                                                0]
                                                                        .answer ??
                                                                    ""));
                                                      }
                                                      if ((questiondata
                                                                  .selectQuestion ??
                                                              0) <
                                                          (questiondata
                                                                      .questionPraticeModel
                                                                      .result
                                                                      ?.length ??
                                                                  0) -
                                                              1) {
                                                        Provider.of<CommanProvider>(
                                                                context,
                                                                listen: false)
                                                            .answerclick(-1);
                                                        Provider.of<ApiProvider>(
                                                                context,
                                                                listen: false)
                                                            .changeQuestion(
                                                                (questiondata
                                                                            .selectQuestion ??
                                                                        0) +
                                                                    1);
                                                      } else {
                                                        Timer(
                                                            const Duration(
                                                                seconds: 0),
                                                            () {
                                                          saveQuestionReport();
                                                          Provider.of<ApiProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changeQuestion(
                                                                  0);

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .correctAnswer(
                                                                  0,
                                                                  questiondata
                                                                          .questionPraticeModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionPraticeModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .inCorrectAnswer(
                                                                  0,
                                                                  questiondata
                                                                          .questionPraticeModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionPraticeModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .answerclick(-1);
                                                        });
                                                        Provider.of<ApiProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectQuestion = 0;
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25.0),
                                                                side: const BorderSide(
                                                                    color:
                                                                        textColorGrey)))),
                                                    child: MyText(
                                                      maltilanguage: true,
                                                      title: "next",
                                                      colors: black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      size: 16,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container();
                    },
                  ),
                ),
              ),
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
    );
  }

  Future<void> saveQuestionReport() async {
    log("message for practice question report  ");
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint("correct answer value === >>> ${correctAns.toString()}");
    log("levelmasterid === >>> ${widget.levelMasterId.toString()}");
    log("categoryid=== >>> ${widget.catId.toString()}");
    log("levelid === >>> ${widget.levelId.toString()}");

    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getSavePraticeQuestionReport(
      Constant.userID ?? "",
      widget.levelMasterId.toString(),
      widget.catId.toString(),
      widget.levelId.toString(),
      (questiondata.questionPraticeModel.result?.length ?? 0).toString(),
      (questiondata.questionPraticeModel.result?.length ?? 0).toString(),
      correctAns.toString(),
    );
    debugPrint('===>get responce ${correctAns.toString()}');
    debugPrint('===>get responce${provider.successModel.status}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PraticeLevelResult()));
      }
    }
  }

  Widget usershimmer() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: CustomWidget.roundrectborder(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              height: 200,
            ),
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

  Widget practicequestionsshimmer() {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: CustomWidget.roundrectborder(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              height: 200,
            ),
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
