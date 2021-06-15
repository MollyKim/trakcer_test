import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trakcer_test/data_model.dart';
import 'package:trakcer_test/tracker.dart';
import 'dialogs.dart';
import 'package:trakcer_test/firestore.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '트래커 테스트 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '트래커 테스트'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  var subscription;
  final List<int> PLAN20MATE = [80, 76, 65, 78, 50, 48, 77, 65, 84, 69];


  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  linkTracker(String condition) async{
    flutterBlue.startScan();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text('플랜이공 기기연결하기'),
        content: SizedBox(
          height: 197,
          width: 298,
          child: StreamBuilder(
              stream: flutterBlue.scanResults,
              builder: (context, snapshot) {
                Set<ScanResult> scanResultSet = Set<ScanResult> ();
                if (snapshot.hasData) {
                  for (var i in snapshot.data) {
                    if (i.advertisementData.manufacturerData.isNotEmpty) {
                      var manufacturerData = i.advertisementData.manufacturerData
                          .values.last;
                      if (manufacturerData.length >= 15 && listEquals(
                          manufacturerData.toList().sublist(0, 10), PLAN20MATE)) {
                        scanResultSet.add(i);
                      }
                    }
                  }
                  List<ScanResult> scanResultData = scanResultSet.toList();
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: scanResultData.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          title: RaisedButton(
                              child: Text(
                                  scanResultData[index].device.name + '\n' +
                                      scanResultData[index].device.id.toString()),
                              onPressed: () {
                                flutterBlue.stopScan();
                                ScanResult scanResult = scanResultData[index];
                                Navigator.pop(context);
                                if(condition=='start')
                                  Future.delayed(Duration.zero, () {
                                    start(scanResult);
                                  });
                                else if(condition=='end')
                                  Future.delayed(Duration.zero, () {
                                    end(scanResult);
                                  });
                              }
                          ),
                        );
                      }
                  );
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  start(ScanResult scanResult) async{
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: 197,
          width: 298,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if(snapshot.hasError)
                return fail(context);
              else if( snapshot.connectionState == ConnectionState.done){
                if(snapshot.data) {
                  Future.delayed(Duration.zero,() {
                    Navigator.pop(context);
                  });
                } else fail(context);
              }
              return connectingDialog(context);
            },
            future: startTracker(flutterBlue, scanResult),
          ),
        ),
      ),
    );
  }

  end(ScanResult scanResult) async{
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: 197,
          width: 298,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if(snapshot.hasError)
                return fail(context);
              else if( snapshot.connectionState == ConnectionState.done){
                if(snapshot.data) {
                  Future.delayed(Duration.zero,() {
                    Navigator.pop(context);
                  });
                } else fail(context);
              }
              return connectingDialog(context);
            },
            future: endTracker(flutterBlue, scanResult),
          ),
        ),
      ),
    );
  }

  showData() async{
    List<TrackerData> data = await getTrackerData();
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('데이터 한눈에 보기'),
            content: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index){
                  return ListTile(
                    title: InkWell(
                      onTap: (){},
                      child: Text(
                          '날짜 : ' + DateFormat('MM/dd hh:mm').format(data[index].createdAt).toString() +'\n'
                          + '측정 결과 : ' +data[index].value.toString() +'분\n'
                          + '기기 : ' + data[index].macAddress.toString()+'\n'),
                    ),
                  );
              },
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () async{
                  bool result = await checkLocationPermissions();
                  if(result)
                    linkTracker('start');
                },
                child: Text('트래커 시작하기'),
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async{
                  bool result = await checkLocationPermissions();
                  if(result)
                    linkTracker('end');
                },
                child: Text('트래커 테스트 종료'),
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async{
                  showData();
                },
                child: Text('트래커 테스트 결과 보기'),
              ),
            ]
        ),
      ),
    );
  }
}




Future<bool> checkLocationPermissions() async {
  bool result = false;
  if (await Permission.location.request().isGranted) {
    result =  true;
  }else{
    await openAppSettings();
  }
  return result;
}
