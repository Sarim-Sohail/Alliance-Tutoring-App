class ContractModel {
  String? contractID;
  String? tutorName;
  String? studentName;
  DateTime? startDate;
  DateTime? endDate;
  double? totalFee;
  int? numberOfSessions;
  String? status;
  Map<String, dynamic>? subjectsTimings;
  Map<String, dynamic>? subjectsPrices;
  List<String>? days;
  List<String>? members;
  List<String>? subjects;
  Map<DateTime, List<String>>? sessionDates;
  bool? isRequest;

  ContractModel({
    this.contractID,
    this.tutorName,
    this.studentName,
    this.startDate,
    this.endDate,
    this.totalFee,
    this.numberOfSessions,
    this.status,
    this.subjectsTimings,
    this.days,
    this.members,
    this.sessionDates,
    this.isRequest,
    this.subjectsPrices,
    this.subjects,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> sessionDatesJson = {};
    if (sessionDates != null) {
      for (MapEntry<DateTime, List<String>> entry in sessionDates!.entries) {
        sessionDatesJson[entry.key.toIso8601String()] = entry.value;
      }
    }
    return {
      'contractID': contractID,
      'tutorName': tutorName,
      'studentName': studentName,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'totalFee': totalFee,
      'numberOfSessions': numberOfSessions,
      'status': status,
      'subjectsTimings': subjectsTimings,
      'subjectsPrices': subjectsPrices,
      'subjects': subjects,
      'days': days,
      'members': members,
      'sessionDates': sessionDatesJson,
      'isRequest':isRequest,
    };
  }

  static ContractModel fromJson(Map<String, dynamic> json) {
    return ContractModel(
      contractID: json['contractID'],
      tutorName: json['tutorName'],
      studentName: json['studentName'],
      startDate: DateTime.tryParse(json['startDate']),
      endDate: DateTime.tryParse(json['endDate']),
      totalFee: json['totalFee']?.toDouble(),
      numberOfSessions: json['numberOfSessions'],
      status: json['status'],
      subjectsTimings: json['subjectsTimings'],
      subjectsPrices: json['subjectsPrices'],
      subjects: json['subjects'],
      days: json['days'],
      members: json['members'],
      isRequest: json['isRequest'],
      sessionDates: (json['sessionDates'] as Map<String, dynamic>?)?.map((dateStr, data) => MapEntry(DateTime.tryParse(dateStr)!, List<String>.from(data))),
    );
  }
}
