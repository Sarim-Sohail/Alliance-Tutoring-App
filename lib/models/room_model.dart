class RoomModel {
  String? roomID;
  Map<String, dynamic>? participants;
  List<String>? members;
  String? lastMessage;
  DateTime? lastMessageSent;

  RoomModel({this.roomID, this.participants, this.lastMessage, this.lastMessageSent, this.members});

  RoomModel.fromMap(Map<String, dynamic> map) {
    roomID = map["roomID"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    lastMessageSent = map["lastMessageSent"].toDate();
    members = (map['members'] as List<dynamic>).map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "roomID": roomID,
      "participants": participants,
      "lastMessage": lastMessage,
      "lastMessageSent": lastMessageSent,
      "members": members
    };
  }
}