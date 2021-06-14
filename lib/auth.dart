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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('로그인 해주세요'),
            InkWell(
              child: Icon(Icons.login,color: Colors.black,),
              onTap: () async{
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
    );
  }
}
