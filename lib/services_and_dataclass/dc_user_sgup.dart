class userSignUp {
  final String username;
  final String email;
  final String phone_number;

  userSignUp(
      {required this.username,
      required this.email,
      required this.phone_number});

  //toJSON
  Map<String, dynamic> toJSON() => {
        "username": username,
        "email": email,
        "phone_number": phone_number,
        "type": "user",
        "phone_verified": false,
        "point": 0
      };

  //getJSON
  factory userSignUp.fromJson(Map<String, dynamic> json) {
    return userSignUp(
        username: json['username'],
        email: json['email'],
        phone_number: json['phone_number']);
  }
}
