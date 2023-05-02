// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatRoomModel {
  final String personA;
  final String personB;
  final String chatRoomId;
  final DateTime createdAt;
  final String nameOfPersonA;
  final String nameOfPersonB;
  final String lastMessage;

  ChatRoomModel({
    required this.personA,
    required this.personB,
    required this.chatRoomId,
    required this.createdAt,
    required this.nameOfPersonA,
    required this.nameOfPersonB,
    required this.lastMessage,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : personA = json['personA'],
        personB = json['personB'],
        chatRoomId = json['chatRoomId'],
        createdAt = json['createdAt'],
        nameOfPersonA = json['nameOfPersonA'],
        nameOfPersonB = json['nameOfPersonB'],
        lastMessage = json['lastMessage'];

  Map<String, dynamic> toJson() {
    return {
      "personA": personA,
      "personB": personB,
      "chatRoomId": chatRoomId,
      "createdAt": createdAt,
      "nameOfPersonA": nameOfPersonA,
      "nameOfPersonB": nameOfPersonB,
      "lastMessage": lastMessage,
    };
  }
}
