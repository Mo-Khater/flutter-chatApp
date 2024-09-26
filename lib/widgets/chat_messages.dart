import 'package:chatapp/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }

          final enteredMessages = chatSnapshots.data!.docs;

          return ListView.builder(
            reverse: true,
            padding:const EdgeInsets.only(left: 40),
            itemCount: enteredMessages.length,
            itemBuilder: (context, index) {
              if (index + 1 < enteredMessages.length &&
                  enteredMessages[index].data()['userId'] ==
                      enteredMessages[index + 1].data()['userId']) {
                return MessageBubble.next(
                    message: enteredMessages[index].data()['text'],
                    isMe: currentUser!.uid ==
                        enteredMessages[index].data()['userId']);
              } else {
                return MessageBubble.first(
                    userImage: enteredMessages[index].data()['userImage'],
                    username: enteredMessages[index].data()['username'],
                    message: enteredMessages[index].data()['text'],
                    isMe: currentUser!.uid ==
                        enteredMessages[index].data()['userId']);
              }
            },
          );
        });
  }
}
