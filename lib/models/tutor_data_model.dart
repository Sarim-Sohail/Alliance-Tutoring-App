class Tutors {
  final String fullName;
  final String dateOfBirth;
  final String email;
  final String address;
  final String gender;
  final String qualification;
  final String degreeNumber;
  final String tutoringMode;
  final String currentEmployment;
  final int yearsOfExperience;
  final int noOfReviews;
  final double rating;
  final bool isVerified;
  final Map<String, double> prices;
  final Map<String, dynamic> timings;
  final List<String> daysOfWeek;
  final bool inContract;
  String degreeDocument = '';
  String profilePicture = '';
  Map<String, dynamic> contractedStudents={};
  final bool isVolunteer;

  Tutors(
      {required this.fullName,
      required this.inContract, 
      required this.prices,
      required this.timings,
      required this.daysOfWeek,
      required this.dateOfBirth,
      required this.email,
      required this.gender,
      required this.address,
      required this.qualification,
      required this.degreeNumber,
      required this.tutoringMode,
      required this.currentEmployment,
      required this.yearsOfExperience,
      required this.noOfReviews,
      required this.rating,
      required this.isVerified,
      required this.degreeDocument,
      required this.profilePicture,
      required this.contractedStudents,
      required this.isVolunteer});

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'address': address,
        'gender': gender,
        'qualification': qualification,
        'degreeNumber': degreeNumber,
        'tutoringMode': tutoringMode,
        'currentEmployment': currentEmployment,
        'yearsOfExperience': yearsOfExperience,
        'numberOfReviews': noOfReviews,
        'rating': rating,
        'isVerified': isVerified,
        'prices': prices,
        'timings': timings,
        'degreeDocument': degreeDocument,
        'profilePicture': profilePicture,
        'inContract': inContract,
        'daysOfWeek': daysOfWeek,
        'contractedStudents': contractedStudents,
        'isVolunteer': isVolunteer,
      };

  static Tutors fromJson(Map<String, dynamic> json) => Tutors(
        fullName: json['fullName'],
        email: json['email'],
        gender: json['gender'],
        dateOfBirth: json['dateOfBirth'],
        address: json['address'],
        qualification: json['qualification'],
        degreeNumber: json['degreeNumber'],
        tutoringMode: json['tutoringMode'],
        currentEmployment: json['currentEmployment'],
        yearsOfExperience: json['yearsOfExperience'],
        noOfReviews: json['numberOfReviews'],
        rating: json['rating'],
        isVerified: json['isVerified'],
        prices: Map<String, double>.from(json['prices']),
        timings: Map<String, dynamic>.from(json['timings']),
        daysOfWeek: (json['daysOfWeek'] as List).map((e) => e as String).toList(),
        degreeDocument: json['degreeDocument'],
        profilePicture: json['profilePicture'], 
        inContract: json['inContract'],
        isVolunteer: json['isVolunteer'],
        contractedStudents: Map<String, dynamic>.from(json['contractedStudents']),
      );
}
