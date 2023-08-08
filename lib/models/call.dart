// ignore_for_file: public_member_api_docs, sort_constructors_first
class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String recevierId;
  final String recevierName;
  final String recevierPic;
  final String callId;
  final bool hasDialled;
  final bool videoCall;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.recevierId,
    required this.recevierName,
    required this.recevierPic,
    required this.callId,
    required this.hasDialled,
    required this.videoCall,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'recevierId': recevierId,
      'recevierName': recevierName,
      'recevierPic': recevierPic,
      'callId': callId,
      'hasDialled': hasDialled,
      'videoCall': videoCall,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      recevierId: map['recevierId'] as String,
      recevierName: map['recevierName'] as String,
      recevierPic: map['recevierPic'] as String,
      callId: map['callId'] as String,
      hasDialled: map['hasDialled'] as bool,
      videoCall: map['videoCall'] as bool,
    );
  }
}
