// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/colors.dart';
import 'package:chatapp/common/widgets/loader.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/call/controller/call_controller.dart';
import 'package:chatapp/features/chat/widgets/chat_list.dart';

import '../../../models/user_model.dart';
import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  List<Widget> actionButtons(WidgetRef ref, BuildContext context) {
    if (!isGroupChat) {
      return [
        IconButton(
          onPressed: () => makeCall(ref, context, true),
          icon: const Icon(Icons.video_call),
          color: Colors.grey,
        ),
        IconButton(
          onPressed: () => makeCall(ref, context, false),
          icon: const Icon(Icons.call),
          color: Colors.grey,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: Colors.grey,
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: Colors.grey,
        )
      ];
    }
  }

  void makeCall(WidgetRef ref, BuildContext context, isVideoCall) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
          isVideoCall,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const Loader();
                  }
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      if (snapshot.data != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              snapshot.data!.isOnline ? 'online' : "offilne",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
        centerTitle: false,
        actions: actionButtons(ref, context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
