import 'package:flutter/material.dart';

Widget connectingDialog(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 25),
      Text("연결 중"),
      SizedBox(height: 16,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Color.fromRGBO(242, 198, 65, 0.5),
            valueColor:
            AlwaysStoppedAnimation(Colors.deepPurpleAccent),
          ),
          SizedBox(width: 10),
          Text("기기와 연결 중입니다.\n 조금만 기다려주세요.", textAlign: TextAlign.left)
        ],
      ),
      SizedBox(height: 18),
      FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onPressed: () {
          Navigator.pop(context, "취소");
        },
        child: SizedBox(
            height: 48,
            width: 128,
            child: Center(
                child: Text("취소"))),
      )
    ],
  );
}

Widget fail(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 25),
      Text("연결 실패"),
      SizedBox(height: 16,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/machine_link/connecting_fail_icon.png'),
          SizedBox(width: 13),
          Text("연결에 실패했습니다.",)
        ],),
      SizedBox(height: 18),
      FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onPressed:(){
          Navigator.pop(context);
        },
        child: SizedBox(
            height: 48,
            width: 128,
            child: Center(child: Text("확인"))),

      )
    ],
  );
}