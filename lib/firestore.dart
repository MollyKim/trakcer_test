import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trakcer_test/data_model.dart';

final FirebaseFirestore store = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;


setTackerData(String macAddress, num value, DateTime now, num battery) async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> data = {
    'createdAt' : now,
    'value' : value,
    'setUserKey' : auth.currentUser.uid,
    'macAddress' : macAddress,
    'battery' : battery,
  };

    store.collection('BetaTestTracker').add(data);
  }

  getTrackerData() async{
    var data = await store.collection('BetaTestTracker').orderBy('createdAt',descending: true).get();
    List<TrackerData> trackerData = data.docs.map((e) => TrackerData.fromMap(e.data())).toList();
    return trackerData;
  }