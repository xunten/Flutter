class QuestionModel {
  QuestionModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  Result({
    this.id,
    this.categoryId,
    this.contestId,
    this.audioType,
    this.audio,
    this.videoType,
    this.video,
    this.levelId,
    this.languageId,
    this.questionLevelMasterId,
    this.image,
    this.question,
    this.questionType,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.answer,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? categoryId;
  int? contestId;
  String? audioType;
  String? audio;
  String? videoType;
  String? video;
  int? levelId;
  int? languageId;
  int? questionLevelMasterId;
  String? image;
  String? question;
  int? questionType;
  String? optionA;
  String? optionB;
  String? optionC;
  String? optionD;
  String? answer;
  String? note;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        contestId: json["contest_id"],
        audioType: json["audio_type"],
        audio: json["audio"],
        videoType: json["video_type"],
        video: json["video"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        questionLevelMasterId: json["question_level_master_id"],
        image: json["image"],
        question: json["question"],
        questionType: json["question_type"],
        optionA: json["option_a"],
        optionB: json["option_b"],
        optionC: json["option_c"],
        optionD: json["option_d"],
        answer: json["answer"],
        note: json["note"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "contest_id": contestId,
        "audio_type": audioType,
        "audio": audio,
        "video_type": videoType,
        "video": video,
        "level_id": levelId,
        "language_id": languageId,
        "question_level_master_id": questionLevelMasterId,
        "image": image,
        "question": question,
        "question_type": questionType,
        "option_a": optionA,
        "option_b": optionB,
        "option_c": optionC,
        "option_d": optionD,
        "answer": answer,
        "note": note,
        "created_at": createdAt,
        "updated_at": updatedAt
      };
}
