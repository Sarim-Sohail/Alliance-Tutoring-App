class UserModel {
  String? fullName;
  String? email;
  String? profilePicture;
  

  UserModel({this.fullName, this.email, this.profilePicture});

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email' : email,
    'profilePicture': profilePicture,
  };

  static UserModel fromJson(Map<String,dynamic> json ) => UserModel(
    fullName: json['fullName'],
    email: json['email'],
    profilePicture : json['profilePicture'],
  );

}