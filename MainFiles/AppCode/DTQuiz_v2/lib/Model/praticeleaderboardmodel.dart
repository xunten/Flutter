class PraticeLeaderboardModel {
  PraticeLeaderboardModel({
    this.status,
    this.message,
    this.result,
    this.user,
  });

  int? status;
  String? message;
  List<Result>? result;
  List<Result>? user;

  factory PraticeLeaderboardModel.fromJson(Map<String, dynamic> json) =>
      PraticeLeaderboardModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"]?.map((x) => Result.fromJson(x)) ?? []),
        user: List<Result>.from(json["user"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
        "user": List<dynamic>.from(user!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.rank,
    this.id,
    this.totalScore,
    this.fullname,
    this.profileImg,
    this.praticeQuizScore,
    this.score,
    this.name,
    this.userTotalScore,
  });

  int? rank;
  int? id;
  int? totalScore;
  String? fullname;
  String? profileImg;
  int? praticeQuizScore;
  int? score;
  String? name;
  int? userTotalScore;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        rank: json["rank"],
        id: json["id"],
        totalScore: json["total_score"],
        fullname: json["fullname"],
        profileImg: json["profile_img"],
        praticeQuizScore: json["pratice_quiz_score"],
        score: json["score"],
        name: json["name"],
        userTotalScore: json["user_total_score"],
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "id": id,
        "total_score": totalScore,
        "fullname": fullname,
        "profile_img": profileImg,
        "pratice_quiz_score": praticeQuizScore,
        "score": score,
        "name": name,
        "user_total_score": userTotalScore,
      };
}
