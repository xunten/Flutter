class LevelPraticeModel {
  LevelPraticeModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LevelPraticeModel.fromJson(Map<String, dynamic> json) =>
      LevelPraticeModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.levelOrder,
    this.score,
    this.winQuestionCount,
    this.totalQuestion,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.categoryId,
    this.isUnlock,
  });

  int? id;
  String? name;
  int? levelOrder;
  int? score;
  int? winQuestionCount;
  int? totalQuestion;
  String? createdAt;
  String? updatedAt;
  int? status;
  int? categoryId;
  int? isUnlock;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        levelOrder: json["level_order"],
        score: json["score"],
        winQuestionCount: json["win_question_count"],
        totalQuestion: json["total_question"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        categoryId: json["category_id"],
        isUnlock: json["is_unlock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "level_order": levelOrder,
        "score": score,
        "win_question_count": winQuestionCount,
        "total_question": totalQuestion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
        "category_id": categoryId,
        "is_unlock": isUnlock,
      };
}
