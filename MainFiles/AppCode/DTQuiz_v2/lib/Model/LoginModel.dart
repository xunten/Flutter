class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result(
      {this.id,
      this.fullname,
      this.username,
      this.email,
      this.password,
      this.mobileNumber,
      this.profileImg,
      this.type,
      this.instagramUrl,
      this.facebookUrl,
      this.twitterUrl,
      this.biodata,
      this.address,
      this.referenceCode,
      this.parentReferenceCode,
      this.praticeQuizScore,
      this.totalScore,
      this.totalPoints,
      this.deviceToken,
      this.status,
      this.isUpdated,
      this.cDate,
      this.userType,
      this.createdAt,
      this.updatedAt,
      this.deviceType});

  int? id;
  String? userType;
  String? fullname;
  String? username;
  String? email;
  String? password;
  String? mobileNumber;
  String? profileImg;
  int? type;
  String? instagramUrl;
  String? facebookUrl;
  String? twitterUrl;
  String? biodata;
  String? address;
  String? referenceCode;
  String? parentReferenceCode;
  int? praticeQuizScore;
  int? totalScore;
  int? totalPoints;
  String? deviceToken;
  String? status;
  int? isUpdated;
  String? cDate;
  String? createdAt;
  String? updatedAt;
  int? deviceType;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobile_number"],
        profileImg: json["profile_img"],
        type: json["type"],
        instagramUrl: json["instagram_url"],
        facebookUrl: json["facebook_url"],
        twitterUrl: json["twitter_url"],
        biodata: json["biodata"],
        address: json["address"],
        deviceType: json["device_type"],
        referenceCode: json["reference_code"],
        parentReferenceCode: json["parent_reference_code"],
        praticeQuizScore: json["pratice_quiz_score"],
        totalScore: json["total_score"],
        totalPoints: json["total_points"],
        deviceToken: json["device_token"],
        status: json["status"],
        isUpdated: json["is_updated"],
        cDate: json["c_date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "username": username,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "profile_img": profileImg,
        "type": type,
        "instagram_url": instagramUrl,
        "facebook_url": facebookUrl,
        "twitter_url": twitterUrl,
        "biodata": biodata,
        "address": address,
        "device_type": deviceType,
        "reference_code": referenceCode,
        "parent_reference_code": parentReferenceCode,
        "pratice_quiz_score": praticeQuizScore,
        "total_score": totalScore,
        "total_points": totalPoints,
        "device_token": deviceToken,
        "status": status,
        "is_updated": isUpdated,
        "c_date": cDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_type": userType,
      };
}
