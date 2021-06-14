import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;


  setStartTackerData(String macAddress, Map<String, dynamic> data) async{
    store.doc('BetaTestTracker/$macAddress')
        .set(data,SetOptions(merge: true));
  }

  setEndTrackerData(String macAddress, num value) async{
    store.doc('BetaTestTracker/$macAddress').update({
      'value': value,
      'updateUserKey' : auth.currentUser.uid
    });
  }