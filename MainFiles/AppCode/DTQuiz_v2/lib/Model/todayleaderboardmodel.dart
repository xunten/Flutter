// To parse this JSON data, do
//
//     final todayLeaderBoardModel = todayLeaderBoardModelFromJson(jsonString);

import 'dart:convert';

TodayLeaderBoardModel todayLeaderBoardModelFromJson(String str) =>
    TodayLeaderBoardModel.fromJson(json.decode(str));

String todayLeaderBoardModelToJson(TodayLeaderBoardModel data) =>
    json.encode(data.toJson());

class TodayLeaderBoardModel {
  int? status;
  String? message;
  List<Result>? result;
  List<Result>? user;

  TodayLeaderBoardModel({
    this.status,
    this.message,
    this.result,
    this.user,
  });

  factory TodayLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      TodayLeaderBoardModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        user: List<Result>.from(json["user"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
        "user": List<dynamic>.from(user?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? rank;
  int? userId;
  int? score;
  int? maxScore;
  String? fullname;
  String? profileImg;
  String? name;
  int? userTotalScore;
  int? userTotalPoints;

  Result({
    this.rank,
    this.userId,
    this.score,
    this.maxScore,
    this.fullname,
    this.profileImg,
    this.name,
    this.userTotalPoints,
    this.userTotalScore,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      rank: json["rank"],
      userId: json["user_id"],
      score: json["score"],
      maxScore: json["max_score"],
      fullname: json["fullname"],
      profileImg: json["profile_img"],
      name: json["name"],
      userTotalScore: json["user_total_score"],
      userTotalPoints: json["user_total_point"]);

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "user_id": userId,
        "score": score,
        "max_score": maxScore,
        "fullname": fullname,
        "profile_img": profileImg,
        "name": name,
        "user_total_score": userTotalScore,
        "user_total_point": userTotalPoints
      };
}
