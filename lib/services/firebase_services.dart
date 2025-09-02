import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<QuerySnapshot> readingsStream({int limit = 10}) {
    return firestore
        .collection('soilReadings')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
  }
}
