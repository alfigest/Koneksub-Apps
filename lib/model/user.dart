class UserDetail {
  final String? email;
  final String? phoneNumber;
  final int? point;
  final String? type;
  final String? username;

  UserDetail({
    this.email,
    this.phoneNumber,
    this.point,
    this.type,
    this.username,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        email: json["email"],
        phoneNumber: json["phone_number"],
        point: json["point"],
        type: json["type"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone_number": phoneNumber,
        "point": point,
        "type": type,
        "username": username,
      };
}
