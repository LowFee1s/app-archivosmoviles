import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthUsuario {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      print('Inicio de sesion con google correcto');

    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }

  }

  Future<void> signOutconGoogle() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    print("Usuario cerrado de sesion!");
  }
}
