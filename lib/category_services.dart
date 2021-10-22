import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  FirebaseFirestore? _instance;

  Future<void> getCollectionFromFirebase() async {
    _instance = FirebaseFirestore.instance;
    CollectionReference categories = _instance!.collection("users");
    var user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snapshot = await categories.doc(user!.uid).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var categoriesData = data['categories'] as List<dynamic>;
    }
  }
}
