import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizapp/Model/CategoryModel.dart';
import 'package:quizapp/Model/GeneralSettingModel.dart';
import 'package:quizapp/Model/LoginModel.dart';
import 'package:quizapp/Model/SuccessModel.dart';
import 'package:quizapp/Model/categorymastermodel.dart';
import 'package:quizapp/Model/coinshistorymodel.dart';
import 'package:quizapp/Model/contentmodel.dart';
import 'package:quizapp/Model/contestleadermodel.dart';
import 'package:quizapp/Model/contestquestionmodel.dart';
import 'package:quizapp/Model/earnmodel.dart';
import 'package:quizapp/Model/earnpointsmodel.dart';
import 'package:quizapp/Model/leaderboardmodel.dart';
import 'package:quizapp/Model/levelmastermodel.dart';
import 'package:quizapp/Model/levelmodel.dart';
import 'package:quizapp/Model/levelpraticemodel.dart';
import 'package:quizapp/Model/notificationmodel.dart';
import 'package:quizapp/Model/packagesmodel.dart';
import 'package:quizapp/Model/pagesmodel.dart';
import 'package:quizapp/Model/praticeleaderboardmodel.dart';
import 'package:quizapp/Model/profilemodel.dart';
import 'package:quizapp/Model/questionmodel.dart';
import 'package:quizapp/Model/questionpraticemodel.dart';
import 'package:quizapp/Model/refertranmodel.dart';
import 'package:quizapp/Model/registrationmodel.dart';
import 'package:quizapp/Model/rewardmodel.dart';
import 'package:quizapp/Model/todayleaderboardmodel.dart';
import 'package:quizapp/Model/winnermodel.dart';
import 'package:quizapp/Model/withdrawallistmodel.dart';
import 'package:quizapp/webservice/apiservice.dart';

class ApiProvider extends ChangeNotifier {
  GeneralSettingModel generalSettingModel = GeneralSettingModel();

  LoginModel loginModel = LoginModel();

  RegistrationModel registrationModel = RegistrationModel();

  CategoryModel categoryModel = CategoryModel();

  LevelModel levelModel = LevelModel();

  QuestionModel questionModel = QuestionModel();
  QuestionModel audioquestionbycategoryModel = QuestionModel();

  ContestQuestionModel contestQuestionModel = ContestQuestionModel();

  ContentModel upcontentModel = ContentModel();
  ContentModel livecontentModel = ContentModel();
  ContentModel endcontentModel = ContentModel();
  ContestLeaderModel contestLeaderModel = ContestLeaderModel();
  WinnerModel winnerModel = WinnerModel();

  ProfileModel profileModel = ProfileModel();
  PagesModel pagesModel = PagesModel();

  ReferTranModel referTranModel = ReferTranModel();
  RewardModel rewardModel = RewardModel();
  CoinsHistoryModel coinsHistoryModel = CoinsHistoryModel();
  EarnModel earnModel = EarnModel();
  SuccessModel successModel = SuccessModel();
  WithdrawalListModel withdrawalListModel = WithdrawalListModel();

  TodayLeaderBoardModel todayLeaderBoardModel = TodayLeaderBoardModel();
  LeaderBoardModel leaderBoardModel = LeaderBoardModel();

  LevelMasterModel levelMasterModel = LevelMasterModel();
  CategoryMasterModel categoryMasterModel = CategoryMasterModel();
  LevelPraticeModel levelPraticeModel = LevelPraticeModel();

  QuestionPraticeModel questionPraticeModel = QuestionPraticeModel();
  PraticeLeaderboardModel praticeLeaderboardModel = PraticeLeaderboardModel();
  PackagesModel packagesModel = PackagesModel();
  NotificationModel notificationModel = NotificationModel();
  EarnPointsModel earnPointsModel = EarnPointsModel();

  bool loading = false;
  String? email, password, type, deviceToken;

  String? firstname, lastname, mobilenumber, fullname, username;

  String? catId;

  int? selectQuestion = 0;

  getGeneralsetting(context) async {
    loading = true;
    generalSettingModel = await ApiService().genaralSetting();
    debugPrint("${generalSettingModel.status}");
    loading = false;
    notifyListeners();
  }

  login(email, username, profileImg, password, type, deviceToken,
      deviceType) async {
    loading = true;
    loginModel = await ApiService().login(
        email, username, profileImg, password, type, deviceToken, deviceType);
    debugPrint("${loginModel.status}");
    loading = false;
    notifyListeners();
  }

  loginwithotp(type, mobile, deviceToken, deviceType) async {
    loading = false;
    loginModel =
        await ApiService().loginwithotp(type, mobile, deviceToken, deviceType);
    debugPrint("login status :== ${loginModel.status}");
    loading = true;
    notifyListeners();
  }

  registration(context, email, password, firstname, lastname, mobilenumber,
      refercode, fullname, username) async {
    loading = true;
    debugPrint('====>$mobilenumber');
    registrationModel = await ApiService().registration(email, password,
        firstname, lastname, mobilenumber, refercode, fullname, username);
    debugPrint("${registrationModel.status}");
    loading = false;
    notifyListeners();
  }

  forgotPassword(email) async {
    loading = true;
    successModel = await ApiService().forgotpassword(email);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getProfile(context, String userId) async {
    loading = true;
    profileModel = await ApiService().profile(userId);
    debugPrint("${profileModel.status}");
    loading = false;
    notifyListeners();
  }

  getUpdateProfile(
      userId, fullname, email, contact, address, File image) async {
    loading = true;
    successModel = await ApiService()
        .updateProfile(userId, fullname, email, contact, address, image);
    debugPrint("${profileModel.status}");
    loading = false;
    notifyListeners();
  }

  getCoinsHistory(userId) async {
    loading = true;
    coinsHistoryModel = await ApiService().coinshistory(userId);
    debugPrint("${coinsHistoryModel.status}");
    loading = false;
    notifyListeners();
  }

  getRewardPoints(userId) async {
    loading = true;
    rewardModel = await ApiService().rewardpoints(userId);
    debugPrint("${referTranModel.status}");
    loading = false;
    notifyListeners();
  }

  getEarnPoints(userId) async {
    loading = true;
    earnModel = await ApiService().earnpoints(userId);
    debugPrint("${earnModel.status}");
    loading = false;
    notifyListeners();
  }

  getReferTransaction(userId) async {
    loading = true;
    referTranModel = await ApiService().referTran(userId);
    debugPrint("${referTranModel.status}");
    loading = false;
    notifyListeners();
  }

  getCategory(context) async {
    loading = true;
    categoryModel = await ApiService().category();
    debugPrint("${categoryModel.status}");
    loading = false;
    notifyListeners();
  }

  getCategoryByLevelMaster(context, masterId) async {
    loading = true;
    categoryMasterModel = await ApiService().categoryByLevelMaster(masterId);
    debugPrint("${categoryMasterModel.status}");
    loading = false;
    notifyListeners();
  }

  getLevel(context, catId, String userID) async {
    loading = true;
    levelModel = await ApiService().level(catId, userID);
    debugPrint("${levelModel.status}");
    loading = false;
    notifyListeners();
  }

  getQuestionByLevel(context, catId, String levelId) async {
    loading = true;
    questionModel = await ApiService().questionByLevel(catId, levelId);
    debugPrint("${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  getUpContent(String listType, String userID) async {
    loading = true;
    upcontentModel = await ApiService().getContest(listType, userID);
    debugPrint("${upcontentModel.status}");
    loading = false;
    notifyListeners();
  }

  getLiveContent(context, String listType, String userID) async {
    loading = true;
    livecontentModel = await ApiService().getContest(listType, userID);
    debugPrint("${livecontentModel.status}");
    loading = false;
    notifyListeners();
  }

  getEndContent(context, String listType, String userID) async {
    loading = true;
    endcontentModel = await ApiService().getContest(listType, userID);
    debugPrint("${endcontentModel.status}");
    loading = false;
    notifyListeners();
  }

  getjoinContest(String contestId, String userID, String point) async {
    loading = true;
    successModel = await ApiService().joinContest(contestId, userID, point);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getContestWinnerList(String contestId) async {
    loading = true;
    winnerModel = await ApiService().winnerbycontest(contestId);
    debugPrint("${winnerModel.status}");
    loading = false;
    notifyListeners();
  }

  getContestLeaderBoard(userId, contestId) async {
    loading = true;
    contestLeaderModel =
        await ApiService().contestleaderBoard(userId, contestId);
    debugPrint("====> ${contestLeaderModel.status}");
    loading = false;
    notifyListeners();
  }

  getQuestionByContest(context, catId) async {
    loading = true;
    contestQuestionModel = await ApiService().questionByContest(catId);
    debugPrint("${contestQuestionModel.status}");
    loading = false;
    notifyListeners();
  }

  getAudioQuestion(categoryId) async {
    loading = true;
    questionModel = await ApiService().audioquestionbycategory(categoryId);
    debugPrint(
        "status of audio question api ========>>>>>>>>>>${questionModel.result?.length}");
    debugPrint(
        "status of audio question api ========>>>>>>>>> ${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  getDailyQuestion(userid) async {
    loading = true;
    questionModel = await ApiService().dailyquestionbycategory();
    debugPrint(
        "status of daily question api ========>>>>>>>>>>${questionModel.result?.length}");
    debugPrint(
        "status of daily question api ========>>>>>>>>> ${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  getTrueFalseQuestion(categoryId) async {
    loading = true;
    questionModel = await ApiService().truefalsequestionbycategory(categoryId);
    debugPrint(
        "status of truefalse question api ========>>>>>>>>>>${questionModel.result?.length}");
    debugPrint(
        "status of truefalse question api ========>>>>>>>>> ${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  getVideoQuestion(categoryId) async {
    loading = true;
    questionModel = await ApiService().videoquestionbycategory(categoryId);
    debugPrint(
        "status of video question api ========>>>>>>>>>>${questionModel.result?.length}");
    debugPrint(
        "status of video question api ========>>>>>>>>> ${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  changeQuestion(int id) {
    selectQuestion = id;
    notifyListeners();
  }

  getSaveQuestionReport(
      context,
      String levelId,
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String categoryId) async {
    loading = true;
    successModel = await ApiService().saveQuestionReport(levelId,
        questionsAttended, totalQuestion, correctAnswers, userId, categoryId);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getSaveVideoQuestionReport(String questionsAttended, String totalQuestion,
      String correctAnswers, String userId, String categoryId) async {
    loading = true;
    successModel = await ApiService().saveVideoQuestionReport(
        questionsAttended, totalQuestion, correctAnswers, userId, categoryId);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getDailyQuestionReport(
    String questionsAttended,
    String totalQuestion,
    String correctAnswers,
    String userId,
  ) async {
    loading = true;
    successModel = await ApiService().saveDailyQuestionReport(
        questionsAttended, totalQuestion, correctAnswers, userId);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getSaveTrueFalseQuestionReport(String questionsAttended, String totalQuestion,
      String correctAnswers, String userId, String categoryId) async {
    loading = true;
    successModel = await ApiService().saveTrueFalseQuestionReport(
        questionsAttended, totalQuestion, correctAnswers, userId, categoryId);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getSaveAudioQuestionReport(String questionsattended, String totalquestion,
      String correctanswers, String userId, String categoryid) async {
    loading = true;
    successModel = await ApiService().saveaudioquestionreport(
        categoryid, totalquestion, questionsattended, correctanswers);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getSaveContestQuestionReport(
      context,
      String contestId,
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String questionJson) async {
    loading = true;
    successModel = await ApiService().saveContestQuestionReport(contestId,
        questionsAttended, totalQuestion, correctAnswers, userId, questionJson);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getTodayLeaderBoard(userId, String levelId) async {
    loading = true;
    todayLeaderBoardModel =
        await ApiService().todayLeaderBoard(userId, levelId);
    debugPrint("${todayLeaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getLeaderBoard(userId, String type) async {
    loading = true;
    leaderBoardModel = await ApiService().leaderBoard(userId, type);
    debugPrint("${leaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getAudioLeaderBoard(userId, String type) async {
    loading = true;
    todayLeaderBoardModel = await ApiService().audioleaderBoard(type);
    debugPrint("${todayLeaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getTrueFalseLeaderBoard(userId, String type) async {
    loading = true;
    todayLeaderBoardModel = await ApiService().truefalseleaderBoard(type);
    debugPrint("${todayLeaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getDailyQuizLeaderBoard(userId, String type) async {
    loading = true;
    todayLeaderBoardModel = await ApiService().dailyQuizleaderBoard(type);
    debugPrint("${todayLeaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getVideoLeaderBoard(userId, String type) async {
    loading = true;
    todayLeaderBoardModel = await ApiService().videoleaderBoard(type);
    debugPrint("${todayLeaderBoardModel.status}");
    loading = false;
    notifyListeners();
  }

  getLevelMaster() async {
    loading = true;
    levelMasterModel = await ApiService().questionLevelMaster();
    debugPrint("${levelMasterModel.status}");
    loading = false;
    notifyListeners();
  }

  getLevelPratice(context, catId, String userID) async {
    loading = true;
    levelPraticeModel =
        await ApiService().practiceLavelByCategoryId(catId, userID);
    debugPrint("${levelPraticeModel.status}");
    loading = false;
    notifyListeners();
  }

  getQuestionByLevelPratice(catId, String levelId, String levelMasterId) async {
    loading = true;
    questionPraticeModel = await ApiService()
        .practiceQuestionByLavel(catId, levelId, levelMasterId);
    debugPrint("${questionModel.status}");
    loading = false;
    notifyListeners();
  }

  getSavePraticeQuestionReport(
      String userId,
      String masterId,
      String categoryId,
      String levelId,
      String totalQuestion,
      String questionsAttended,
      String correctAnswers) async {
    loading = true;
    successModel = await ApiService().savePraticeQuestionReport(
      userId,
      masterId,
      categoryId,
      levelId,
      totalQuestion,
      correctAnswers,
      questionsAttended,
    );
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getPraticeLeaderBoard(userId, type) async {
    loading = true;
    praticeLeaderboardModel =
        await ApiService().practiseLeaderBoard(userId, type);
    debugPrint(
        "Practice Leader board status === >>> ${praticeLeaderboardModel.status}");
    loading = false;
    notifyListeners();
  }

  getPackage() async {
    loading = true;
    debugPrint(" status of api ====>>>>${packagesModel.status}");
    packagesModel = await ApiService().packages();
    debugPrint(" status of api ====>>>>${packagesModel.status}");
    debugPrint(" result of api =====>>>>${packagesModel.result}");
    debugPrint(" message  of api =====>>>>>${packagesModel.message}");
    loading = false;
    notifyListeners();
  }

  getaddTranscation(String userId, String planId, String amount, String point,
      String transactionid) async {
    loading = true;
    successModel = await ApiService()
        .addTransacation(userId, planId, amount, point, transactionid);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getWithdrawalRequest(
      String userId, String paymentdetail, String paymenttype, point) async {
    loading = true;
    successModel = await ApiService()
        .withdrwalrequest(userId, paymentdetail, paymenttype, point);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getWithdrawalList(
    String userId,
  ) async {
    loading = true;
    withdrawalListModel = await ApiService().withdrawallist(userId);
    debugPrint("${withdrawalListModel.status}");
    loading = false;
    notifyListeners();
  }

  getNotification(context, userId) async {
    loading = true;
    notificationModel = await ApiService().notification(userId);
    debugPrint("${profileModel.status}");
    loading = false;
    notifyListeners();
  }

  getPages() async {
    loading = true;
    pagesModel = await ApiService().pages();
    debugPrint("get pages api status ===>>>> ${pagesModel.status}");
    loading = false;
    notifyListeners();
  }

  getReadNotification(userId, id) async {
    loading = true;
    successModel = await ApiService().readNotification(userId, id);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  getEarnPointList() async {
    loading = true;
    earnPointsModel = await ApiService().earnPointslist();
    debugPrint("${earnPointsModel.status}");
    loading = false;
    notifyListeners();
  }

  getaddRewardPoints(userId, id, type) async {
    loading = true;
    successModel = await ApiService().rewardPoints(userId, id, type);
    debugPrint("${successModel.status}");
    loading = false;
    notifyListeners();
  }

  clearprovider() {
    questionModel = QuestionModel();
    todayLeaderBoardModel = TodayLeaderBoardModel();
    questionPraticeModel = QuestionPraticeModel();
    selectQuestion = 0;
  }
}
