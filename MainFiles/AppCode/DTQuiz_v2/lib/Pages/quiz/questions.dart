// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/quiz/levelresult.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/Utils/Constant.dart';
import 'package:quizapp/Utils/adhelper.dart';
import 'package:quizapp/Utils/sharepref.dart';
import 'package:quizapp/provider/apiprovider.dart';
import 'package:quizapp/provider/commanprovider.dart';
import 'package:quizapp/widget/customwidget.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mynetimage.dart';
import 'package:quizapp/widget/mytext.dart';
import 'package:quizapp/widget/seekbar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class Questions extends StatefulWidget {
  final String? catId, levelId, levelname;
  final int type;
  const Questions(
      {Key? key, this.catId, this.levelId, this.levelname, required this.type})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

late ApiProvider questiondata;

class _QuestionsState extends State<Questions> {
  late bool isPlaying;
  // final CustomTimerController _controller = CustomTimerController();

  SharePref sharePref = SharePref();

  String? userId;

  final playerC = AudioPlayer();
  final playerW = AudioPlayer();

  double percent = 0.0;

  Timer? timer;
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  int answercnt = 1;
  int selectAnswer = -1;

  List<double> questionList = [];

  AudioPlayer player = AudioPlayer();
  double sliderValue = 0.0;
  @override
  void initState() {
    isPlaying = false;
    log("type == ${widget.type}");
    log("Your User ID is  == ${Constant.userID}");

    getUserId();
    super.initState();
  }

  getUserId() async {
    questiondata = Provider.of<ApiProvider>(context, listen: false);
    log("question data information ====>>> ${questiondata.questionModel.result?.length}");
    if (widget.type == 1) {
      log("type 1 is calling ------");
      await questiondata.getQuestionByLevel(
          context, widget.catId, widget.levelId.toString());
    } else if (widget.type == 2) {
      log("type 2 is calling ------");
      await questiondata.getAudioQuestion(widget.catId);

      playAudioQuestion();
      log("message   =====  >>>> ${questiondata.questionModel.result?.length}");
    } else if (widget.type == 3) {
      log("type 3 is calling ------");
      await questiondata.getVideoQuestion(widget.catId);
      playthevideo();
    } else if (widget.type == 4) {
      log("type 4 is calling ------");
      await questiondata.getTrueFalseQuestion(widget.catId);
    } else if (widget.type == 5) {
      log("type 5 is calling ------");
      await questiondata.getDailyQuestion(Constant.userID);
    }

    AdHelper.createInterstitialAd();
    AdHelper.createRewardedAd();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<void> playAudioQuestion() async {
    try {
      log("play the audio");

      await player.setUrl(
        questiondata
                .questionModel.result?[questiondata.selectQuestion ?? 0].audio
                .toString() ??
            "",
        initialPosition: const Duration(seconds: 0),
      );
      player.play();

      log("isplaying ++ $isPlaying");
      if (isPlaying == true) {
        isPlaying == false;
        player.pause();
      } else {
        isPlaying == true;
        player.play();
      }
      log("isplaying ++ $isPlaying");
    } catch (e) {
      print("Error: $e");
    }
  }

  playthevideo() {
    log("message of selected question  ====>>>>>> ${questiondata.questionModel.result?[questiondata.selectQuestion ?? 0].video.toString()}");
    _controller = VideoPlayerController.network(questiondata
            .questionModel.result?[questiondata.selectQuestion ?? 0].video
            .toString() ??
        "");
    log("message of selected question  ====>>>>>> ${questiondata.questionModel.result?[questiondata.selectQuestion ?? 0].video.toString()}");

    setupcontroller();
   
  }

  setupcontroller() {
    _chewieController = ChewieController(
      aspectRatio: 16 / 9,
      showOptions: false,
      videoPlayerController: _controller,
      startAt: const Duration(milliseconds: 0),
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      fullScreenByDefault: false,
      allowFullScreen: true,
      hideControlsTimer: const Duration(seconds: 0),
      showControls: false,
      allowedScreenSleep: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: black,
        handleColor: appDarkColor,
        backgroundColor: green,
        bufferedColor: red,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: black,
        handleColor: appDarkColor,
        backgroundColor: green,
        bufferedColor: red,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: MyText(
            colors: white,
            title: errorMessage,
            textalign: TextAlign.center,
            size: 14,
            fontWeight: FontWeight.w600,
            maltilanguage: false,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
        );
      },
    );
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
  void dispose() async {
    log("message dispose the value");
    player.dispose();
    questiondata.clearprovider();
    // _controller.dispose();
    _chewieController?.dispose();

    super.dispose();
  }


  getAnswer(int qindex, index) {
    if (index == 0) {
      return 'A. ${questiondata.questionModel.result?[qindex].optionA ?? ""}';
    } else if (index == 1) {
      return 'B. ${questiondata.questionModel.result?[qindex].optionB ?? ""}';
    } else if (index == 2) {
      return 'C. ${questiondata.questionModel.result?[qindex].optionC ?? ""}';
    } else {
      return 'D. ${questiondata.questionModel.result?[qindex].optionD ?? ""}';
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
                maltilanguage: widget.type == 1 ? false : true,
                title: widget.type == 1
                    ? widget.levelname.toString()
                    : widget.type == 2
                        ? "audioquestion"
                        : widget.type == 3
                            ? "videoquestion"
                            : widget.type == 4
                                ? "true/false"
                                : 'dailyquiz',
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
                                  '${((questiondata.selectQuestion ?? 0) + 1)} / ${questiondata.questionModel.result?.length ?? 0}',
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
                      log('====>>>>${((questiondata.selectQuestion ?? 0) + 1)} / ${questiondata.questionModel.result?.length ?? 0}');
                      if (questiondata.loading) {
                      
                        return Center(
                          child: questionsshimmer(),
                        );

                      } else {
                        log("===> Selection ${questiondata.selectQuestion}");
                        return questiondata.loading
                            ? Center(
                                child: questionsshimmer(),
                              )
                            : questiondata.questionModel.result?.length
                                        .toInt() !=
                                    0
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  100))),
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 30.0,
                                                    lineWidth: 4.0,
                                                    animation: false,
                                                    percent: percent / 100,
                                                    center: Text(
                                                      percent
                                                          .toInt()
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    progressColor:
                                                        Colors.redAccent,
                                                  ),
                                                ),
                                              ),
                                              // Question Count
                                              Positioned(
                                                top: 50,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30, right: 30),
                                                  child:
                                                      Consumer<CommanProvider>(
                                                    builder: (context,
                                                        commandProvider,
                                                        child) {
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
                                                                animation:
                                                                    false,
                                                                lineHeight: 3.0,
                                                                percent:
                                                                    (commandProvider
                                                                            .correctPercent /
                                                                        100),
                                                                barRadius:
                                                                    const Radius
                                                                        .circular(20),
                                                                progressColor:
                                                                    Colors
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
                                                                animation:
                                                                    false,
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
                                                        .questionModel
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
                                                    AutoSizeText(
                                                      questiondata
                                                              .questionModel
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    widget.type == 2
                                                        ? Container(
                                                            height: 110,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    lightpurple,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25)),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 25,
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                      isPlaying
                                                                          ? Icons
                                                                              .play_arrow
                                                                          : Icons
                                                                              .pause,
                                                                      size: 40,
                                                                      color:
                                                                          appDarkColor,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      playAudioQuestion();
                                                                      setState(
                                                                          () {
                                                                        isPlaying =
                                                                            !isPlaying;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                StreamBuilder<
                                                                    PositionData>(
                                                                  stream:
                                                                      _positionDataStream,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    final positionData =
                                                                        snapshot
                                                                            .data;
                                                                    return SeekBar(
                                                                      duration: positionData
                                                                              ?.duration ??
                                                                          Duration
                                                                              .zero,
                                                                      position: positionData
                                                                              ?.position ??
                                                                          Duration
                                                                              .zero,
                                                                      bufferedPosition: positionData
                                                                              ?.bufferedPosition ??
                                                                          Duration
                                                                              .zero,
                                                                      onChangeEnd:
                                                                          player
                                                                              .seek,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : widget.type == 1
                                                            ? MyNetImage(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.25,
                                                                fit:
                                                                    BoxFit.fill,
                                                                imagePath: questiondata
                                                                        .questionModel
                                                                        .result?[
                                                                            questiondata.selectQuestion ??
                                                                                0]
                                                                        .image
                                                                        .toString() ??
                                                                    "")
                                                            : widget.type == 3
                                                                ? AspectRatio(
                                                                    aspectRatio:
                                                                        16 / 9,
                                                                    child: questiondata.questionModel.result?[0].video?.length.toInt() ==
                                                                            0
                                                                        ? const Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                            color:
                                                                                black,
                                                                          ))
                                                                        : Chewie(
                                                                            controller:
                                                                                _chewieController!,
                                                                          ),
                                                                  )
                                                                : widget.type ==
                                                                        3
                                                                    ? SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.18,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              AutoSizeText(
                                                                            questiondata.questionModel.result?[questiondata.selectQuestion ?? 0].question.toString() ??
                                                                                "",
                                                                            style: GoogleFonts.inter(
                                                                                fontSize: 22,
                                                                                color: textColorGrey,
                                                                                fontWeight: FontWeight.w500),
                                                                            minFontSize:
                                                                                12,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                6,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                    const SizedBox(height: 5),
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
                                                            .questionModel
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
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: widget.type ==
                                                          3
                                                      ? 2
                                                      :
                                                    
                                                      1,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: (questiondata
                                                                  .questionModel
                                                                  .result?[
                                                                      questiondata
                                                                              .selectQuestion ??
                                                                          0]
                                                                  .image
                                                                  ?.length ??
                                                              0) >
                                                          0
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          1.8 /
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              7)
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              14),
                                                ),
                                                itemCount:
                                                    widget.type == 4 ? 2 : 4,
                                                itemBuilder:
                                                    (BuildContext ctx, index) {
                                                  return Consumer<
                                                      CommanProvider>(
                                                    builder: (context, answer,
                                                        child) {
                                                      debugPrint(
                                                          'select Answer===>${answer.selectAnswer}');
                                                      debugPrint(
                                                          'correct Answer===>${answer.correctAns}');
                                                      debugPrint(
                                                          'index===>$index');
                                                      return InkWell(
                                                        onTap: () {
                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .answerclick(
                                                                  index);
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
                                                                    padding: const EdgeInsets
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
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(25))),
                                                                    child:
                                                                        AutoSizeText(
                                                                      getAnswer(
                                                                          (questiondata.selectQuestion ??
                                                                              0),
                                                                          index),
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              white,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      minFontSize:
                                                                          10,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
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
                                                                    padding: const EdgeInsets
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
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(25))),
                                                                    child:
                                                                        AutoSizeText(
                                                                      getAnswer(
                                                                          (questiondata.selectQuestion ??
                                                                              0),
                                                                          index),
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              white,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      minFontSize:
                                                                          10,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
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
                                                                    padding: const EdgeInsets
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
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(25))),
                                                                    child:
                                                                        AutoSizeText(
                                                                      getAnswer(
                                                                          (questiondata.selectQuestion ??
                                                                              0),
                                                                          index),
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              white,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      minFontSize:
                                                                          10,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
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
                                                                    padding: const EdgeInsets
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
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(25))),
                                                                    child:
                                                                        AutoSizeText(
                                                                      getAnswer(
                                                                          (questiondata.selectQuestion ??
                                                                              0),
                                                                          index),
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                      minFontSize:
                                                                          10,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxLines:
                                                                          1,
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
                                        ),
                                        Container(
                                          height: 150,
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  widget.type == 3 ? 20 : 25),
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
                                                                .questionModel
                                                                .result?[
                                                                    questiondata
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
                                                                          .questionModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));

                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .corAns(int.parse(questiondata
                                                                      .questionModel
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
                                                                          .questionModel
                                                                          .result
                                                                          ?.length ??
                                                                      0,
                                                                  int.parse(questiondata
                                                                          .questionModel
                                                                          .result?[questiondata.selectQuestion ??
                                                                              0]
                                                                          .answer ??
                                                                      ""));
                                                          Provider.of<CommanProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .corAns(int.parse(questiondata
                                                                      .questionModel
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
                                                                        .questionModel
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
                                                                    listen:
                                                                        false)
                                                                .answerclick(
                                                                    -1);
                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .corAns(-1);
                                                            Provider.of<ApiProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeQuestion(
                                                                    (questiondata.selectQuestion ??
                                                                            0) +
                                                                        1);
                                                          });
                                                        } else {
                                                          Timer(
                                                              const Duration(
                                                                  seconds: 0),
                                                              () {
                                                            widget.type == 1
                                                                ? saveQuestionReport()
                                                                : widget.type ==
                                                                        2
                                                                    ? saveAudioQuestionReport()
                                                                    : widget.type ==
                                                                            3
                                                                        ? saveVideoQuestionReport()
                                                                        : widget.type ==
                                                                                4
                                                                            ? saveTrueFalseQuestionReport()
                                                                            : saveDailyQuestionReport();
                                                            Provider.of<ApiProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeQuestion(
                                                                    0);

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .correctAnswer(
                                                                    0,
                                                                    questiondata
                                                                            .questionModel
                                                                            .result
                                                                            ?.length ??
                                                                        0,
                                                                    int.parse(questiondata
                                                                            .questionModel
                                                                            .result?[questiondata.selectQuestion ??
                                                                                0]
                                                                            .answer ??
                                                                        ""));

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .inCorrectAnswer(
                                                                    0,
                                                                    questiondata
                                                                            .questionModel
                                                                            .result
                                                                            ?.length ??
                                                                        0,
                                                                    int.parse(questiondata
                                                                            .questionModel
                                                                            .result?[questiondata.selectQuestion ??
                                                                                0]
                                                                            .answer ??
                                                                        ""));

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .answerclick(
                                                                    -1);

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
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
                                                              .questionModel
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
                                                                        .questionModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionModel
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
                                                                        .questionModel
                                                                        .result
                                                                        ?.length ??
                                                                    0,
                                                                int.parse(questiondata
                                                                        .questionModel
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
                                                                      .questionModel
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
                                                        widget.type == 2
                                                            ? player.stop()
                                                            : false;
                                                        widget.type == 2
                                                            ? playAudioQuestion()
                                                            : false;
                                                        widget.type == 3
                                                            ? _controller
                                                                .pause()
                                                            : false;
                                                        widget.type == 3
                                                            ? _chewieController
                                                                ?.pause()
                                                            : false;
                                                        widget.type == 3
                                                            ? playthevideo()
                                                            : false;
                                                      } else {
                                                        Timer(
                                                          const Duration(
                                                              seconds: 0),
                                                          () {
                                                            widget.type == 1
                                                                ? saveQuestionReport()
                                                                : false;
                                                            widget.type == 2
                                                                ? saveAudioQuestionReport()
                                                                : false;
                                                            widget.type == 3
                                                                ? saveVideoQuestionReport()
                                                                : false;
                                                            widget.type == 4
                                                                ? saveTrueFalseQuestionReport()
                                                                : false;
                                                            widget.type == 5
                                                                ? saveDailyQuestionReport()
                                                                : false;

                                                            Provider.of<ApiProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeQuestion(
                                                                    0);

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .correctAnswer(
                                                                    0,
                                                                    questiondata
                                                                            .questionModel
                                                                            .result
                                                                            ?.length ??
                                                                        0,
                                                                    int.parse(questiondata
                                                                            .questionModel
                                                                            .result?[questiondata.selectQuestion ??
                                                                                0]
                                                                            .answer ??
                                                                        ""));

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .inCorrectAnswer(
                                                              0,
                                                              questiondata
                                                                      .questionModel
                                                                      .result
                                                                      ?.length ??
                                                                  0,
                                                              int.parse(questiondata
                                                                      .questionModel
                                                                      .result?[
                                                                          questiondata.selectQuestion ??
                                                                              0]
                                                                      .answer ??
                                                                  ""),
                                                            );

                                                            Provider.of<CommanProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .answerclick(
                                                                    -1);

                                                            Provider.of<ApiProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .selectQuestion = 0;
                                                          },
                                                        );
                                                  
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.0),
                                                          side: const BorderSide(
                                                              color:
                                                                  textColorGrey),
                                                        ),
                                                      ),
                                                    ),
                                                    child: MyText(
                                                      maltilanguage: true,
                                                      title: "next",
                                                      colors: black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: MyImage(
                                    imagePath: "assets/images/nodata.png",
                                    height: 350,
                                    width: 350,
                                  ));
                      }
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
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint(correctAns.toString());

    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getSaveQuestionReport(
        context,
        widget.levelId.toString(),
        (questiondata.questionModel.result?.length ?? 0).toString(),
        (questiondata.questionModel.result?.length ?? 0).toString(),
        correctAns.toString(),
        Constant.userID ?? "",
        widget.catId.toString());
    debugPrint('===>get responce ${provider.successModel.status}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LevelResult(
                  levelId: widget.levelId,
                  resulttype: widget.type,
                )));
      }
    }
  }

  Future<void> saveAudioQuestionReport() async {
    log("Audio report saving api called ");
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint("Total Correct answer ====>>>>>${correctAns.toString()}");
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getSaveAudioQuestionReport(
        (questiondata.questionModel.result?.length ?? 0).toString(),
        (questiondata.questionModel.result?.length ?? 0).toString(),
        correctAns.toString(),
        Constant.userID ?? "",
        widget.catId.toString());
    debugPrint('===>get responce${provider.successModel.status}');
    debugPrint('===>get responce${provider.successModel.result}');
    debugPrint('===>get responce${provider.successModel.message}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LevelResult(
                  resulttype: widget.type,
                )));
      }
    }
  }

  Future<void> saveVideoQuestionReport() async {
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint(correctAns.toString());
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getSaveVideoQuestionReport(
        (questiondata.questionModel.result?.length ?? 0).toString(),
        (questiondata.questionModel.result?.length ?? 0).toString(),
        correctAns.toString(),
        Constant.userID ?? "",
        widget.catId.toString());
    debugPrint('===>get responce${provider.successModel.status}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LevelResult(
                  resulttype: widget.type,
                )));
      }
    }
  }

  Future<void> saveTrueFalseQuestionReport() async {
    log("save truefalse report api calling ==>>");
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint(correctAns.toString());
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getSaveTrueFalseQuestionReport(
        (questiondata.questionModel.result?.length ?? 0).toString(),
        (questiondata.questionModel.result?.length ?? 0).toString(),
        correctAns.toString(),
        Constant.userID ?? "",
        widget.catId.toString());
    debugPrint('===>get responce${provider.successModel.status}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LevelResult(
                  resulttype: widget.type,
                )));
      }
    }
  }

  Future<void> saveDailyQuestionReport() async {
    log("save daily report api calling ==>>");
    int correctAns =
        Provider.of<CommanProvider>(context, listen: false).correctanswer;
    debugPrint(correctAns.toString());
    final provider = Provider.of<ApiProvider>(context, listen: false);
    await provider.getDailyQuestionReport(
      (questiondata.questionModel.result?.length ?? 0).toString(),
      (questiondata.questionModel.result?.length ?? 0).toString(),
      correctAns.toString(),
      Constant.userID ?? "",
    );
    debugPrint('===>get responce${provider.successModel.status}');
    if (provider.loading) {
      const CircularProgressIndicator();
    } else {
      if (provider.successModel.status == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LevelResult(
                  resulttype: widget.type,
                )));
      }
    }
  }

  Widget questionsshimmer() {
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
