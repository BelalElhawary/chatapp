// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:chatapp/common/enums/message_enum.dart';
import 'package:chatapp/common/providers/message_reply_provider.dart';
import 'package:chatapp/common/widgets/loader.dart';
import 'package:chatapp/features/chat/controller/chat_controller.dart';
import 'package:chatapp/features/chat/widgets/my_message_card.dart';
import 'package:chatapp/features/chat/widgets/sender_message_card.dart';
import 'package:chatapp/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum type,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message,
            isMe,
            type,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat
          ? ref
              .read(chatControllerProvider)
              .groupChatStream(widget.recieverUserId)
          : ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var message = snapshot.data![index];
            if (!message.isSeen &&
                message.recieverId == FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                  context, widget.recieverUserId, message.messageId);
            }
            if (message.recieverId == widget.recieverUserId) {
              return MyMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                type: message.type,
                repliedText: message.repliedMessage,
                username: message.repliedTo,
                repliedMessageType: message.repliedMessageType,
                onLeftSwipe: () => onMessageSwipe(
                  message.text,
                  true,
                  message.type,
                ),
                isSeen: message.isSeen,
              );
            }
            return SenderMessageCard(
              message: message.text,
              date: DateFormat.Hm().format(message.timeSent),
              type: message.type,
              username: message.repliedTo,
              repliedMessageType: message.repliedMessageType,
              onRightSwipe: () => onMessageSwipe(
                message.text,
                false,
                message.type,
              ),
              repliedText: message.repliedMessage,
            );
          },
        );
      },
    );
  }
}
