import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthUsuario {

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
     // 'email',
     // 'https://www.googleapis.com/auth/firebase',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive'
    ],
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CloudServicios cloudServicios = CloudServicios();

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await cloudServicios.google1SignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var dato = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (!dato.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "useridGoogleDrive": "",
            "useremailGoogleDrive": "",
            "usertokenGoogleDrive": "",
            "useronedrivetoken": "",
          });
        }
      }

      print('Inicio de sesion con google correcto');

    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }

  }

  Future<String?> signAccountConnectWithGoogle() async {
    String dato = "";
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await cloudServicios.google1SignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
            "usertokenGoogleDrive": googleSignInAuthentication.accessToken,
            "useridGoogleDrive": cloudServicios.google1SignIn.currentUser!.id,
            "useremailGoogleDrive": cloudServicios.google1SignIn.currentUser!.email,
      }).then((value) => dato = "Conectado");

      print('Inicio de sesion conectada con google correcto');

      return dato;


    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }

  }

  Future<String?> signOutAccount1ConnectWithGoogle() async {
      String dato = "";
      try {

        await cloudServicios.google1SignIn.signOut();

        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .update({
              "usertokenGoogleDrive": "",
              "useridGoogleDrive": "",
              "useremailGoogleDrive": "",
        }).then((value) => dato = "Conectado");

        print('Se cerro sesion conectada con google correcto');

        return dato;


      } on FirebaseAuthException catch (error) {
        print(error.message);
        throw error;
      }

    }

  Future<void> signOutconGoogle() async {
    await cloudServicios.google1SignIn.signOut();
    await firebaseAuth.signOut();
    print("Usuario cerrado de sesion!");
  }

  Future<String?> signInwithMicrosoft() async {
    var dato;
    try {
      final OAuthProvider microsoftProvider = OAuthProvider("microsoft.com");

      microsoftProvider.setCustomParameters({
        "tenant": "caca9011-7b6a-44de-861f-095a2ca883b7"
      });

      var userCredential = await firebaseAuth.signInWithProvider(microsoftProvider);

      if (userCredential != null) {
        print("Acceso al token correctamente realizado. ");
        dato = userCredential.credential!.accessToken;
      } else {
        dato = "";
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var dato = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (!dato.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "useridGoogleDrive": "",
            "useremailGoogleDrive": "",
            "usertokenGoogleDrive": "",
            "useronedrivetoken": userCredential.credential!.accessToken,
          });
        }

      }

      print('Inicio de sesion con google correcto');

      return dato;

    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }

  }

  Future<void> signOutconMicrosoft() async {
    await firebaseAuth.signOut();
    print("Usuario cerrado de sesion!");
  }
}
