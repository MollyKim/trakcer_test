import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:trakcer_test/firestore.dart';

startTracker(FlutterBlue flutterBlue, ScanResult scanResult ) async{
  List<BluetoothCharacteristic> characteristic;
  DateTime now = DateTime.now();
print(now);
  try {
    await scanResult.device.connect();
    List<BluetoothService> service = await scanResult.device.discoverServices();
      characteristic = service[2].characteristics;

    await _startStream(scanResult,characteristic,now);
    await Future.delayed(Duration(milliseconds: 500));

    return true;
  } catch (e) {
    print('에러 : $e');
    await scanResult.device.disconnect();
    throw e;
  }
}

_startStream(ScanResult scanResult, List<BluetoothCharacteristic> characteristic,DateTime now ) async{
  bool start = false;

  String nowTime = DateFormat.Hms().format(now);
  nowTime = nowTime.replaceAll(":", "");
  String startCommend = 'START'+nowTime;
print(startCommend);
  if(!characteristic[1].isNotifying)
    await characteristic[1].setNotifyValue(true);

  StreamSubscription subscription;
  subscription = characteristic[1].value.listen((data) async {
    print('data : $data');
    if(data.isEmpty){
      await characteristic[0].write(utf8.encode(startCommend),withoutResponse: true);
    }
    else {
      String code = String.fromCharCodes(data,0,2);
      print('code : $code');
      data = data.sublist(2);
      if( code == 'ST') {
        start = true;
      }
    }
    if(start == true){
      print('시작함');
      await subscription.cancel();
      if(characteristic[1].isNotifying)
        await characteristic[1].setNotifyValue(false);
      await scanResult.device.disconnect();
    }
  });
}

endTracker(FlutterBlue flutterBlue, ScanResult scanResult ) async{
  List<BluetoothCharacteristic> characteristic;
  DateTime now = DateTime.now();
  print(now);
  try {
    await scanResult.device.connect();
    List<BluetoothService> service = await scanResult.device.discoverServices();
    characteristic = service[2].characteristics;

    await _endStream(scanResult,characteristic,now);
    await Future.delayed(Duration(milliseconds: 500));

    return true;
  } catch (e) {
    print('에러 : $e');
    await scanResult.device.disconnect();
    throw e;
  }
}

_endStream(ScanResult scanResult, List<BluetoothCharacteristic> characteristic,DateTime now ) async{
  bool end = false;
  bool act = false;

  if(!characteristic[1].isNotifying)
    await characteristic[1].setNotifyValue(true);

  StreamSubscription subscription;
  subscription = characteristic[1].value.listen((data) async {
    print('data : $data');
    if(data.isEmpty){
      await characteristic[0].write(utf8.encode('ACT2'), withoutResponse: true);
    }
    else {
      String code = String.fromCharCodes(data,0,2);
      print('code : $code');
      data = data.sublist(2);
      if( code == 'A2') {
        act = true;
        num value = (data[0] + data[1] * 256 + data[2] * 65536) ;// /60;
        await setTackerData(scanResult.device.id.toString(), value.round(), now );
        await characteristic[0].write(utf8.encode('DEL1'), withoutResponse: true);
      }
      if( code == 'D1')
        end = true;
    }
    if(end == true && act == true){
      print('측정 끝남');
      await subscription.cancel();
      if(characteristic[1].isNotifying)
        await characteristic[1].setNotifyValue(false);
      await scanResult.device.disconnect();
    }
  });
}