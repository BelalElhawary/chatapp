class GroupModel {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeSent;

  GroupModel({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupPic: map['groupPic'] as String,
      membersUid: List<String>.from(map['membersUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }

  GroupModel copyWith({
    String? senderId,
    String? name,
    String? groupId,
    String? lastMessage,
    String? groupPic,
    List<String>? membersUid,
    DateTime? timeSent,
  }) {
    return GroupModel(
      senderId: senderId ?? this.senderId,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      lastMessage: lastMessage ?? this.lastMessage,
      groupPic: groupPic ?? this.groupPic,
      membersUid: membersUid ?? this.membersUid,
      timeSent: timeSent ?? this.timeSent,
    );
  }
}
