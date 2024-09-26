import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessage();
  }
}

class _NewMessage extends State<NewMessage> {
  final newMessageController = TextEditingController();

  void _submitMessage() async {
    final newMessage = newMessageController.text;

    if (newMessage.isEmpty) {
      return;
    }

    newMessageController.clear();
    FocusScope.of(context).unfocus();

    final currentUser = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': newMessage,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'enter message'),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              controller: newMessageController,
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
