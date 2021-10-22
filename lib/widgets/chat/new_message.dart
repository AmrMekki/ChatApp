import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = new TextEditingController();

  FirebaseFirestore? _instance;

  Future<void> getCollectionFromFirebase() async {
    _instance = FirebaseFirestore.instance;
    CollectionReference categories = _instance!.collection("users");
    var user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snapshot = await categories.doc(user!.uid).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    }
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    var user = FirebaseAuth.instance.currentUser;
    final username = user!.email!.split("@");
    var snapData;
    getCollectionFromFirebase();
    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection("users");
    // var now = reference.doc(user!.uid);
    // var noww = now.path;

    // final stream = await FirebaseFirestore.instance
    //     .collection("/users/bWY1fOepv1UBKhR3xUjdde9ZN9D2")
    //     .snapshots()
    //     .first;
    FirebaseFirestore.instance.collection("chat").add(
      {
        "text": _enteredMessage,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        "username": username[0],
        "userImage":
            "https://firebasestorage.googleapis.com/v0/b/flutter-chat-5957a.appspot.com/o/userImages%2FbWY1fOepv1UBKhR3xUjdde9ZN9D2.jpg?alt=media&token=9cfa4fc0-0261-475e-a78f-de56809454cc"
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Send message..."),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
