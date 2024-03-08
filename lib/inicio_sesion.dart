import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class InicioSesion extends StatelessWidget {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );


    final UserCredential authResult = await firebaseAuth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = firebaseAuth.currentUser;
      assert(user.uid == currentUser!.uid);

      print('Inicio de sesion con google correcto: $user');

      return user;
    }

    return null;

  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("Usuario cerrado de sesion!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de sesion"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Inicia sesion con Google"),
          onPressed: () {
            signInWithGoogle();
          },
        ),
      ),
    );
  }
}