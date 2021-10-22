import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    final user = FirebaseAuth.instance.currentUser;
    late var chatDocs;
    FirebaseFirestore.instance
        .collection("chat")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen(
      (event) {
        chatDocs = event.docs;
        itemCount = event.docs.length;
      },
    );
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          reverse: true,
          itemCount: itemCount,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]["text"],
            chatDocs[index]["userId"] == user!.uid,
            chatDocs[index]["username"],
            chatDocs[index]["userImage"],
            ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}
