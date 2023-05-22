class MessageModel {
  String? messageID;
  String? sender;
  String? text;
  bool? isSeen;
  DateTime? sentAt;
  

  MessageModel({this.sender, this.text, this.isSeen, this.sentAt, this.messageID});

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'text': text,
    'isSeen': isSeen,
    'sentAt' : sentAt,
    'messageID': messageID
  };

  static MessageModel fromJson(Map<String,dynamic> json ) => MessageModel(
    sender: json['sender'],
    text: json['text'],
    isSeen: json['isSeen'],
    sentAt: json['sentAt'].toDate(),
    messageID: json['messageID'],
  );

}