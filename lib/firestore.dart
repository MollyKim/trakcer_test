import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;


setTackerData(String macAddress, num value, DateTime now) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> data = {
    'createdAt' : now,
    'value' : value,
    'setUserKey' : auth.currentUser.uid,
  };

    store.collection('BetaTestTracker/$macAddress/log').add(data);
  }