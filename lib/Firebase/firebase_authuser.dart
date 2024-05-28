import 'dart:convert';

import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
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
            "usertokenrefreshGoogleDrive": "",
            "useronedrivetokenrefresh": "",
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


// Inicia el flujo de autorización OAuth 2.0
  Future<void> startAuthorization() async {
  // URL de autorización de Microsoft
    final authorizationEndpoint = Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/authorize');

  // URL de token de Microsoft
    final tokenEndpoint = Uri.parse('https://login.microsoftonline.com/common/oauth2/v2.0/token');

  // ID de cliente de tu aplicación
    final clientId = 'ccbefcba-c090-4c47-a300-98bd8115f1e6';

  // URI de redirección de tu aplicación
    final redirectUri = 'com.movilesproyecto.appmovilesproyecto17://settingpage';
    // Construye la URL de autorización
    final url = Uri.https(authorizationEndpoint.authority, authorizationEndpoint.path, {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'scope': 'openid profile offline_access',
    });

    // Redirige al usuario a la URL de autorización
    final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: "com.movilesproyecto.appmovilesproyecto17");

    if (result == null) {
      print("El usuario cerro el login");
      return;
    }
    // Extrae el código de autorización de la URL de redirección
    final code = Uri.parse(result).queryParameters['code'];

    // Intercambia el código de autorización por tokens
    final response = await http.post(
      tokenEndpoint,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
        'code': code,
      },
    );

    // Extrae el token de acceso y el token de actualización de la respuesta
    final accessToken = jsonDecode(response.body)['access_token'];
    final refreshToken = jsonDecode(response.body)['refresh_token'];

    print('Access token: $accessToken');
    print('Refresh token: $refreshToken');

    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({
      "useroneDrivetokenrefresh": refreshToken,
      "useroneDrivetoken": accessToken,
    });

    print('Inicio de sesion conectada con microsoft correcto');
  }


  Future<String?> signInConectionWithMicrosoft(String username, String password) async {
    var clientId = 'ccbefcba-c090-4c47-a300-98bd8115f1e6';
    var tenantId = 'caca9011-7b6a-44de-861f-095a2ca883b7';
    var clientSecret = 'H~D8Q~MQLJspaXKv5UDC~pWq1pbrrNKVvj~hzbOJ';
    var scope = 'https://graph.microsoft.com/.default';
    var url = 'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token';


    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'scope': scope,
        'client_secret': clientSecret,
        'grant_type': 'password',
        'username': username, // Añade el nombre de usuario
        'password': password,
      },
    );

    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body);

      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "useroneDrivetokenrefresh": jsonResponse['refresh_token'].toString(),
        "useroneDrivetoken": jsonResponse['access_token'].toString(),
      });

      print('Inicio de sesion conectada con microsoft correcto');
      print('${jsonResponse.toString()}');

      return jsonResponse['access_token'].toString();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<String?> refreshtokenMicrosoft(String refreshtokenmicrosoft) async {
    var clientId = 'ccbefcba-c090-4c47-a300-98bd8115f1e6';
    var tenantId = 'caca9011-7b6a-44de-861f-095a2ca883b7';
    var clientSecret = 'H~D8Q~MQLJspaXKv5UDC~pWq1pbrrNKVvj~hzbOJ';
    var scope = 'https://graph.microsoft.com/.default openid profile offline_access';
    var url = 'https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token';

    var refreshtoken = refreshtokenmicrosoft;

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': refreshtoken,
        'grant_type': 'authorization_code',
        'scope': scope,
      },
    );

    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body);

      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "useroneDrivetokenrefresh": jsonResponse['refresh_token'].toString(),
      });

      print('Se actualizo el token de la sesion conectada con microsoft correcto');
      print('${jsonResponse.toString()}');

      return jsonResponse['access_token'].toString();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<String?> signOutConectionWithMicrosoft() async {
    var dato;

    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "useroneDrivetoken": "",
      }).then((value) => dato = "Conectado");

      print('Se cerro sesion conectada con microsoft correcto');

      return dato;

    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }
  }



  Future<String?> signInwithMicrosoft() async {
    var dato;
    var datorefresh;
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

        var dato1 = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (!dato1.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "useridGoogleDrive": "",
            "useremailGoogleDrive": "",
            "usertokenGoogleDrive": "",
            "usertokenrefreshGoogleDrive": "",
            "useronedrivetokenrefresh": "",
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
