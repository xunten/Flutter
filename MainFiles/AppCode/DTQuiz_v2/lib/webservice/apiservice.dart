// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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
import 'package:quizapp/Model/paymentoptionmodel.dart';
import 'package:quizapp/Model/paytmmodel.dart';
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
import 'package:quizapp/Utils/Constant.dart';

class ApiService {
  String baseurl = Constant().baseurl;
  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );
  }

  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel generalSettingModel;
    String generalsetting = "general_setting";
    Response response = await dio.post('$baseurl$generalsetting');
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("generalsetting apiservice:===>${response.data}");
      generalSettingModel = GeneralSettingModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return generalSettingModel;
  }

  Future<LoginModel> login(
      email, username, profileImg, pass, type, devicetoken, deviceType) async {
    LoginModel loginmodel;
    String login = "login";
    Response response = await dio.post('$baseurl$login',
        data: FormData.fromMap({
          'email': email,
          'fullname': username,
          "profile_img": profileImg != null
              ? (MultipartFile.fromFileSync(
                  (profileImg?.path.toString() ?? "")))
              : "",
          'password': pass,
          'type': type,
          'device_token': devicetoken,
          'device_type': deviceType
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Login apiservice:===>${response.data}");
      loginmodel = LoginModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return loginmodel;
  }

  Future<LoginModel> loginwithotp(
      int type, String mobile, String deviceToken, int deviceType) async {
    LoginModel loginmodel;
    String login = "login";
    Response response = await dio.post('$baseurl$login',
        data: FormData.fromMap({
          'type': type,
          'mobile_number': mobile,
          'device_token': deviceToken,
          'device_type': deviceType,
        }));
    if (response.statusCode == 200) {
      loginmodel = LoginModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
    return loginmodel;
  }

  Future<SuccessModel> forgotpassword(String email) async {
    SuccessModel successModel;
    String login = "forgot_password";
    Response response =
        await dio.post('$baseurl$login', data: ({'email': email}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("ForgotPassword apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<RegistrationModel> registration(
      String email,
      String pass,
      String firstname,
      String lastname,
      String mobilenumber,
      String refercode,
      String fullname,
      String username) async {
    RegistrationModel registrationModel;
    String registration = "registration";
    Response response = await dio.post('$baseurl$registration',
        data: ({
          'email': email,
          'password': pass,
          'first_name': firstname,
          'last_name': lastname,
          'mobile_number': mobilenumber,
          'parent_reference_code': refercode,
          'fullname': fullname,
          'username': username
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("generalsetting apiservice:===>${response.data}");
      registrationModel = RegistrationModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return registrationModel;
  }

  // get_payment_option API
  Future<PaymentOptionModel> getPaymentOption() async {
    PaymentOptionModel paymentOptionModel;
    String paymentOption = "get_payment_option";
    debugPrint("paymentOption API :==> $baseurl$paymentOption");
    Response response = await dio.post(
      '$baseurl$paymentOption',
    );

    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  Future<CategoryModel> category() async {
    CategoryModel categoryModel;
    String category = "get_category";
    Response response = await dio.post('$baseurl$category');
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Category apiservice:===>${response.data}");
      categoryModel = CategoryModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return categoryModel;
  }

  Future<LevelModel> level(String catId, String userId) async {
    LevelModel levelModel;
    String level = "get_level";
    Response response = await dio.post('$baseurl$level',
        data: ({'category_id': catId, 'user_id': userId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("level apiservice:===>${response.data}");
      levelModel = LevelModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return levelModel;
  }

  Future<QuestionModel> questionByLevel(String catId, String levelId) async {
    QuestionModel questionModel;
    String level = "get_question_by_level";
    Response response = await dio.post('$baseurl$level',
        data: ({'category_id': catId, 'level_id': levelId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Question apiservice:===>${response.data}");
      questionModel = QuestionModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return questionModel;
  }

  Future<ProfileModel> profile(String userId) async {
    ProfileModel profileModel;
    String profile = "profile";
    Response response = await dio.post('$baseurl$profile',
        data: ({'user_id': Constant.userID ?? ""}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Profile apiservice:===>${response.data}");
      profileModel = ProfileModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return profileModel;
  }

  Future<SuccessModel> updateProfile(
      userId, fullname, email, contact, address, image) async {
    SuccessModel successModel;
    String profile = "update_profile";
    Response response = await dio.post('$baseurl$profile',
        data: FormData.fromMap({
          'user_id': userId,
          "fullname": fullname,
          "email": email,
          "mobile_number": contact,
          "biodata": address,
          "profile_img": await MultipartFile.fromFile(image.path,
              filename: basename(image.path))
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Profile apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<ReferTranModel> referTran(String userId) async {
    ReferTranModel referTranModel;
    String profile = "refer_transaction";
    Response response =
        await dio.post('$baseurl$profile', data: ({'user_id': userId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Refer apiservice:===>${response.data}");
      referTranModel = ReferTranModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return referTranModel;
  }

  Future<EarnModel> earnpoints(String userId) async {
    EarnModel earnModel;
    String profile = "get_earn_transaction";
    Response response =
        await dio.post('$baseurl$profile', data: ({'user_id': userId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Earn apiservice:===>${response.data}");
      earnModel = EarnModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return earnModel;
  }

  Future<CoinsHistoryModel> coinshistory(String userId) async {
    CoinsHistoryModel coinsHistoryModel;
    String profile = "get_package_transaction";
    Response response = await dio.post('$baseurl$profile',
        data: ({'user_id': Constant.userID}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Refer apiservice:===>${response.data}");
      coinsHistoryModel = CoinsHistoryModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return coinsHistoryModel;
  }

  Future<RewardModel> rewardpoints(String userId) async {
    RewardModel rewardModel;
    String profile = "get_reward_points";
    Response response =
        await dio.post('$baseurl$profile', data: ({'user_id': userId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Refer apiservice:===>${response.data}");
      rewardModel = RewardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return rewardModel;
  }

  Future<ContentModel> getContest(String listType, String userId) async {
    ContentModel contentModel;
    String content = "get_contest";
    Response response = await dio.post('$baseurl$content',
        data: ({'list_type': listType, 'user_id': Constant.userID}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("getContest apiservice:===>${response.data}");
      contentModel = ContentModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return contentModel;
  }

  Future<SuccessModel> joinContest(
      String contestId, String userId, String point) async {
    SuccessModel successModel;
    String content = "join_contest";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'contest_id': contestId,
          'user_id': Constant.userID,
          'point': point
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("joinContest apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<ContestLeaderModel> contestleaderBoard(
      String userId, int contestId) async {
    ContestLeaderModel contestLeaderModel;
    String contestleaderboard = "get_contest_leaderboard";
    log('====> api $contestleaderboard');
    log('====> userId $userId');
    log('====> contestId $contestId');
    Response response = await dio.post('$baseurl$contestleaderboard',
        data: ({'user_id': Constant.userID, 'contest_id': contestId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Contest leaderBoard apiservice:===>${response.data}");
      contestLeaderModel = ContestLeaderModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return contestLeaderModel;
  }

  Future<WinnerModel> winnerbycontest(String contestId) async {
    WinnerModel winnerModel;
    String content = "get_winner_by_contest";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'contest_id': contestId,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("winnerModel apiservice:===>${response.data}");
      winnerModel = WinnerModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return winnerModel;
  }

  Future<ContestQuestionModel> questionByContest(String contestId) async {
    ContestQuestionModel contestQuestionModel;
    String level = "get_question_by_contest";
    Response response =
        await dio.post('$baseurl$level', data: ({'contest_id': contestId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Question apiservice:===>${response.data}");
      contestQuestionModel = ContestQuestionModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return contestQuestionModel;
  }

  Future<PagesModel> pages() async {
    PagesModel pagesModel;
    String getpages = "get_pages";
    Response response = await dio.post(
      '$baseurl$getpages',
    );
    debugPrint("${response.data}");
    pagesModel = PagesModel.fromJson((response.data));
    return pagesModel;
  }

  Future<QuestionModel> audioquestionbycategory(categoryid) async {
    QuestionModel audioquestionbycategoryModel;
    String audioquestionbycategory = "get_audio_question_by_category";
    Response response = await dio.post('$baseurl$audioquestionbycategory',
        data: ({'category_id': categoryid}));
    debugPrint("${response.data}");
    audioquestionbycategoryModel = QuestionModel.fromJson((response.data));
    return audioquestionbycategoryModel;
  }

  Future<QuestionModel> dailyquestionbycategory() async {
    QuestionModel dailyquestionbycategoryModel;
    String dailyquestionbycategory = "get_daily_quiz_question";
    Response response = await dio.post('$baseurl$dailyquestionbycategory',
        data: ({'user_id': Constant.userID}));
    debugPrint("${response.data}");
    dailyquestionbycategoryModel = QuestionModel.fromJson((response.data));
    return dailyquestionbycategoryModel;
  }

  Future<QuestionModel> truefalsequestionbycategory(categoryid) async {
    QuestionModel truefalsequestionbycategoryModel;
    String truefalsequestionbycategory = "get_true_false_question_by_category";
    Response response = await dio.post('$baseurl$truefalsequestionbycategory',
        data: ({'category_id': categoryid}));
    debugPrint("${response.data}");
    truefalsequestionbycategoryModel = QuestionModel.fromJson((response.data));
    return truefalsequestionbycategoryModel;
  }

  Future<QuestionModel> videoquestionbycategory(categoryid) async {
    QuestionModel videoquestionbycategoryModel;
    String videoquestionbycategory = "get_video_question_by_category";
    Response response = await dio.post('$baseurl$videoquestionbycategory',
        data: ({'category_id': categoryid}));
    debugPrint("${response.data}");
    videoquestionbycategoryModel = QuestionModel.fromJson((response.data));
    return videoquestionbycategoryModel;
  }

  Future<SuccessModel> saveaudioquestionreport(
      categoryid, totalquestion, questionsattended, correctanswers) async {
    SuccessModel successModel;
    String saveaudioquestionreport = "save_audio_question_report";
    Response response = await dio.post('$baseurl$saveaudioquestionreport',
        data: ({
          'category_id': categoryid,
          'user_id': Constant.userID,
          'total_question': totalquestion,
          'questions_attended': questionsattended,
          'correct_answers': correctanswers
        }));
    debugPrint("Audio responce data ==>>> ${response.data}");
    successModel = SuccessModel.fromJson((response.data));
    return successModel;
  }

  Future<SuccessModel> saveQuestionReport(
      String levelId,
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String categoryId) async {
    SuccessModel successModel;
    String content = "save_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'level_id': levelId,
          'user_id': Constant.userID,
          'questions_attended': questionsAttended,
          'total_question': totalQuestion,
          'correct_answers': correctAnswers,
          'category_id': categoryId
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<SuccessModel> saveVideoQuestionReport(
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String categoryId) async {
    SuccessModel successModel;
    String content = "save_video_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'questions_attended': questionsAttended,
          'total_question': totalQuestion,
          'correct_answers': correctAnswers,
          'category_id': categoryId
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<SuccessModel> saveDailyQuestionReport(
    String questionsAttended,
    String totalQuestion,
    String correctAnswers,
    String userId,
  ) async {
    SuccessModel successModel;
    String content = "save_daily_quiz_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'questions_attended': questionsAttended,
          'total_question': totalQuestion,
          'correct_answers': correctAnswers,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<SuccessModel> saveTrueFalseQuestionReport(
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String categoryId) async {
    SuccessModel successModel;
    String content = "save_true_false_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'questions_attended': questionsAttended,
          'total_question': totalQuestion,
          'correct_answers': correctAnswers,
          'category_id': categoryId
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<SuccessModel> saveContestQuestionReport(
      String contestId,
      String questionsAttended,
      String totalQuestion,
      String correctAnswers,
      String userId,
      String questionJson) async {
    SuccessModel successModel;
    String content = "save_contest_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'contest_id': contestId,
          'user_id': userId,
          'questions_attended': questionsAttended,
          'total_questions': totalQuestion,
          'correct_answers': correctAnswers,
          'question_json': questionJson
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Contest Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<TodayLeaderBoardModel> todayLeaderBoard(
      String userId, String levelId) async {
    TodayLeaderBoardModel todayLeaderBoardModel;
    String leaderboard = "get_today_leaderboard";
    Response response = await dio.post('$baseurl$leaderboard',
        data: ({'user_id': Constant.userID, 'level_id': levelId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("TodayLeaderBoard apiservice:===>${response.data}");
      todayLeaderBoardModel = TodayLeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return todayLeaderBoardModel;
  }

  Future<LeaderBoardModel> leaderBoard(String userId, String type) async {
    LeaderBoardModel leaderBoardModel;
    String leaderboard = "get_leaderboard";
    Response response = await dio.post('$baseurl$leaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("leaderBoard apiservice:===>${response.data}");
      leaderBoardModel = LeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return leaderBoardModel;
  }

  Future<TodayLeaderBoardModel> audioleaderBoard(String type) async {
    TodayLeaderBoardModel audioleaderBoardModel;
    String audioleaderboard = "get_audio_leaderboard";
    Response response = await dio.post('$baseurl$audioleaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Audio leaderBoard apiservice:===>${response.data}");
      audioleaderBoardModel = TodayLeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return audioleaderBoardModel;
  }

  Future<TodayLeaderBoardModel> truefalseleaderBoard(String type) async {
    TodayLeaderBoardModel truefalseleaderBoardModel;
    String truefalseleaderboard = "get_true_false_leaderboard";
    Response response = await dio.post('$baseurl$truefalseleaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("True False leaderBoard apiservice:===>${response.data}");
      truefalseleaderBoardModel =
          TodayLeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return truefalseleaderBoardModel;
  }

  Future<TodayLeaderBoardModel> dailyQuizleaderBoard(String type) async {
    TodayLeaderBoardModel dailyQuizleaderBoardModel;
    String dailyQuizleaderboard = "get_daily_quiz_leaderboard";
    Response response = await dio.post('$baseurl$dailyQuizleaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("leaderBoard apiservice:===>${response.data}");
      dailyQuizleaderBoardModel =
          TodayLeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return dailyQuizleaderBoardModel;
  }

  Future<TodayLeaderBoardModel> videoleaderBoard(String type) async {
    TodayLeaderBoardModel videoleaderBoardModel;
    String videoleaderboard = "get_video_leaderboard";
    Response response = await dio.post('$baseurl$videoleaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("leaderBoard apiservice:===>${response.data}");
      videoleaderBoardModel = TodayLeaderBoardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return videoleaderBoardModel;
  }

  Future<LevelMasterModel> questionLevelMaster() async {
    LevelMasterModel levelMasterModel;
    String level = "get_levelmaster";
    Response response = await dio.post('$baseurl$level');
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Question level apiservice:===>${response.data}");
      levelMasterModel = LevelMasterModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return levelMasterModel;
  }

  Future<CategoryMasterModel> categoryByLevelMaster(String masterId) async {
    CategoryMasterModel categoryMasterModel;
    String category = "get_category_by_levelmaster";
    Response response = await dio.post('$baseurl$category',
        data: ({
          'question_level_master_id': masterId,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("categoryMasterModel apiservice:===>${response.data}");
      categoryMasterModel = CategoryMasterModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return categoryMasterModel;
  }

  Future<LevelPraticeModel> practiceLavelByCategoryId(
      String catId, String userId) async {
    LevelPraticeModel levelPraticeModel;
    String level = "get_lavel_by_category";
    Response response = await dio.post('$baseurl$level',
        data: ({'category_id': catId, 'user_id': userId}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("levelpratice apiservice:===>${response.data}");
      levelPraticeModel = LevelPraticeModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return levelPraticeModel;
  }

  Future<QuestionPraticeModel> practiceQuestionByLavel(
      String catId, String levelId, String levelMasterId) async {
    QuestionPraticeModel questionPraticeModel;
    String level = "get_practice_question_by_level";
    Response response = await dio.post('$baseurl$level',
        data: ({
          'category_id': catId,
          'level_id': levelId,
          'question_level_master_id': levelMasterId
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Question apiservice:===>${response.data}");
      questionPraticeModel = QuestionPraticeModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return questionPraticeModel;
  }

  Future<SuccessModel> savePraticeQuestionReport(
    String userId,
    String masterId,
    String categoryId,
    String levelId,
    String totalQuestion,
    String questionsAttended,
    String correctAnswers,
  ) async {
    SuccessModel successModel;
    String content = "save_practice_question_report";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'question_level_master_id': masterId,
          'category_id': categoryId,
          'level_id': levelId,
          'total_question': totalQuestion,
          'question_attended': questionsAttended,
          'correct_answers': correctAnswers,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Save Question apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<PraticeLeaderboardModel> practiseLeaderBoard(
      String userId, String type) async {
    PraticeLeaderboardModel praticeLeaderboardModel;
    String leaderboard = "get_practice_leaderboard";
    Response response = await dio.post('$baseurl$leaderboard',
        data: ({'user_id': Constant.userID, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("PraticeLeaderBoard apiservice:===>${response.data}");
      praticeLeaderboardModel =
          PraticeLeaderboardModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return praticeLeaderboardModel;
  }

  Future<PackagesModel> packages() async {
    PackagesModel packagesModel;
    String profile = "get_packages";
    Response response = await dio.post('$baseurl$profile');
    if (response.statusCode == 200) {
      debugPrint("Package apiservice:===>${response.data}");
      packagesModel = PackagesModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return packagesModel;
  }

  Future<SuccessModel> addTransacation(
      userId, planId, amount, point, transactionid) async {
    SuccessModel successModel;
    String content = "add_package_transaction";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'plan_subscription_id': planId,
          'transaction_amount': amount,
          'point': point,
          'transaction_id': transactionid
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("add_transaction apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<PayTmModel> getPaytmToken(merchantID, orderId, custmoreID, channelID,
      txnAmount, website, callbackURL, industryTypeID) async {
    PayTmModel payTmModel;
    String paytmToken = "get_payment_token";
    debugPrint("paytmToken API :==> $baseurl$paytmToken");
    Response response = await dio.post(
      '$baseurl$paytmToken',
      data: {
        'MID': merchantID,
        'order_id': orderId,
        'CUST_ID': custmoreID,
        'CHANNEL_ID': channelID,
        'TXN_AMOUNT': txnAmount,
        'WEBSITE': website,
        'CALLBACK_URL': callbackURL,
        'INDUSTRY_TYPE_ID': industryTypeID,
      },
    );

    payTmModel = PayTmModel.fromJson(response.data);
    return payTmModel;
  }

  Future<SuccessModel> withdrwalrequest(
      String userId, String paymentdetail, String paymenttype, point) async {
    SuccessModel successModel;
    String content = "withdrawal_request";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
          'payment_detail': paymentdetail,
          'payment_type': paymenttype,
          'point': point
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Withdrawal Request apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }

  Future<WithdrawalListModel> withdrawallist(
    String userId,
  ) async {
    WithdrawalListModel withdrawalistModel;
    String content = "withdrawal_list";
    Response response = await dio.post('$baseurl$content',
        data: ({
          'user_id': Constant.userID,
        }));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("Withdrawal List apiservice:===>${response.data}");
      withdrawalistModel = WithdrawalListModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return withdrawalistModel;
  }

  Future<NotificationModel> notification(userId) async {
    NotificationModel notificationModel;
    String profile = "get_notification";
    Response response = await dio.post('$baseurl$profile',
        data: ({
          'user_id': userId,
        }));
    if (response.statusCode == 200) {
      debugPrint("Notification apiservice:===>${response.data}");
      notificationModel = NotificationModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return notificationModel;
  }

  Future<SuccessModel> readNotification(userId, id) async {
    SuccessModel successModel;
    String profile = "read_notification";
    Response response = await dio.post('$baseurl$profile',
        data: ({
          'user_id': userId,
          'notification_id': id,
        }));
    if (response.statusCode == 200) {
      debugPrint("Read Notification apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load data');
    }
    return successModel;
  }

  Future<EarnPointsModel> earnPointslist() async {
    EarnPointsModel earnPointsModel;
    String level = "earn_point";
    Response response = await dio.post('$baseurl$level');
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("earnPointsModel level apiservice:===>${response.data}");
      earnPointsModel = EarnPointsModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return earnPointsModel;
  }

  Future<SuccessModel> rewardPoints(userId, id, type) async {
    SuccessModel successModel;
    String level = "reward_points";
    Response response = await dio.post('$baseurl$level',
        data: ({'user_id': userId, 'reward_points': id, 'type': type}));
    debugPrint("${response.data}");
    if (response.statusCode == 200) {
      debugPrint("successModel level apiservice:===>${response.data}");
      successModel = SuccessModel.fromJson((response.data));
    } else {
      throw Exception('Failed to load album');
    }
    return successModel;
  }
}
