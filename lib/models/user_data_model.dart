class Users {
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String address;
  final String gender;
  String? profilePicture;
  List<String> conversations;
  final bool isTutor;

  Users(
      {required this.conversations,
      required this.isTutor, 
      required this.fullName,
      this.profilePicture,
      required this.dateOfBirth,
      required this.email,
      required this.gender,
      required this.address});

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'address': address,
        'gender': gender,
        'isTutor': isTutor,
        'profilePicture': '',
        'conversations': conversations,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        fullName: json['fullName'],
        email: json['email'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        address: json['address'],
        profilePicture: json['profilePicture'],
        isTutor: json['isTutor'],
        conversations:
            (json['conversations'] as List).map((e) => e as String).toList(),
      );
}
