import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoachModesService {
  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;

  Future<Map<String,dynamic>?> getTodayCoachMode() async{
    final user=_auth.currentUser;
    if(user==null) return null;

    final snapshot=await _firestore.collection("coachModes").where("userId",isEqualTo:user.uid).orderBy("createdAt",descending: true).limit(1).get();

    if(snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.data();
  }
}