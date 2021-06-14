import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trakcer_test/home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    GoogleSignInAuthentication googleAuth;
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 페이지')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('트래커 테스트 측정 어플입니다.'),
              SizedBox(height: 20),
              Text('하루 이내의 데이터만 측정 가능합니다.'),
              SizedBox(height: 50),
              RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login,color: Colors.black,),
                    Text('구글 아이디로 로그인하기'),
                  ],
                ),
                onPressed: () async{
                  try {
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                    if (googleSignInAccount != null) {
                      googleAuth =
                      await googleSignInAccount.authentication;
                      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
                        fAuth.signInWithCredential(GoogleAuthProvider.credential(
                            idToken: googleAuth.idToken,
                            accessToken: googleAuth.accessToken));
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
