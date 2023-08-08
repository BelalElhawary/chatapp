// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatapp/common/enums/message_enum.dart';

class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> phoneUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCantSee;
  final MessageEnum type;

  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.phoneUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCantSee,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'phoneUrl': phoneUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCantSee,
      'type': type.type,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      phoneUrl: List<String>.from((map['phoneUrl'] as List<String>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      whoCantSee: List<String>.from((map['whoCanSee'] as List<String>)),
      type: MessageEnum.values.byName(map['type'] as String),
    );
  }
}
