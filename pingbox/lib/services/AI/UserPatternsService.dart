import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPatternsService{
  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;

  Future<Map<String,dynamic>?> getUserPatterns() async{
    final user=_auth.currentUser;
    if(user==null) return null;

    final doc=await _firestore.collection("userPatterns").doc(user.uid).get();
    if(!doc.exists) return null;

    return doc.data();
  }
}