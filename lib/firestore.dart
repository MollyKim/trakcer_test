import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trakcer_test/data_model.dart';
final FirebaseFirestore store = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;


setTackerData(String macAddress,String name, num value, DateTime now, num battery) async{
  await FirebaseAuth.instance.signInAnonymously();
  Map<String, dynamic> data = {
    'createdAt' : now,
    'value' : value,
    'macAddress' : macAddress,
    'battery' : battery,
    'name' : name,
  };

    store.collection('BetaTestTracker').add(data);
  }

  getTrackerData() async{
    var data = await store.collection('BetaTestTracker').orderBy('createdAt',descending: true).get();
    List<TrackerData> trackerData = data.docs.map((e) => TrackerData.fromMap(e.data())).toList();
    return trackerData;
  }