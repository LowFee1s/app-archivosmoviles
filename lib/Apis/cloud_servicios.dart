import 'dart:async';
import 'dart:io' as io;
import 'dart:convert' as convert;
import 'package:aad_oauth/model/config.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class CloudServicios {
  // OneDrive


  /*void getAuthorizationCode11() async {
    PublicClientApplication pca = await PublicClientApplication.createPublicClientApplication(
      "ccbefcba-c090-4c47-a300-98bd8115f1e6",
      authority: "https://login.microsoftonline.com/caca9011-7b6a-44de-861f-095a2ca883b7",
    );

    var result = await pca.acquireTokenInteractive(
      scopes: ['User.Read'],
    );

    if (result != null) {
      print('Access token: ${result.accessToken}');
    } else {
      print('Failed to acquire token');
    }
  }*/

  Future<String> getAuthorizationCode11() async {
    Map<String, String> parameters = {
      'client_id': 'ccbefcba-c090-4c47-a300-98bd8115f1e6',
      'response_type': 'code',
      'redirect_uri': 'https://paginadetareasfime.firebaseapp.com/__/auth/handler',
      'response_mode': 'query',
      'scope': 'User.Read',
      'state': '12345',
    };


    Uri url = Uri.https(
      'login.microsoftonline.com',
      '/caca9011-7b6a-44de-861f-095a2ca883b7/oauth2/v2.0/authorize',
      parameters,
    );

    try {
      final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: 'com.movilesproyecto.appmovilesproyecto17');

      if (result != null) {
        final authorizationCode = Uri.parse(result).queryParameters['code'];
        if (authorizationCode != null) {
          print('Authorization code: $authorizationCode');
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set({
              "oneDriveToken": authorizationCode,
            });
            print('Authorization code: $authorizationCode');
          }
          return authorizationCode;

        } else {
          print('No se pudo obtener el código de autorización.');
          return "";
        }
      } else {
        print('No se obtuvo ningún resultado de la autenticación.');
        return "";
      }
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        print('El usuario cerró el navegador antes de completar el inicio de sesión.');
      }
      return "";
    }
  }


  bool isConectadoGoogleDrive = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isConectadoOneDrive = false;
  bool isConectadoDropbox = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive'
    ],
  );

  Future<String> getFirebaseaccount(credentialGoogle) async {
    try {

      var user = await firebaseAuth.signInWithCredential(credentialGoogle);

      if (user != null) {
       return "aceptado";
      }

      return "";

    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }
  }

  var valor = "";
  Future<String> tokensend1(data) async {
    try {


      User? user = FirebaseAuth.instance.currentUser;
      valor = "";
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set({
        "oneDriveToken": data,
      }).then((value) => valor = "true");

      return valor;


    } on FirebaseAuthException catch (error) {
      print(error.message);
      throw error;
    }
  }

  Future<String?> getAuthorizationCode() async {
    try{

      final OAuthProvider microsoftProvider = OAuthProvider("microsoft.com");

      microsoftProvider.setCustomParameters({
        "tenant": "caca9011-7b6a-44de-861f-095a2ca883b7"
      });

      var userCredential = await firebaseAuth.signInWithProvider(microsoftProvider);

      if (userCredential != null) {
        print("Acceso al token correctamente realizado. ");

      }

      final OAuthCredential oAuthCredential = userCredential.credential as OAuthCredential;
      final String? accessToken = oAuthCredential.accessToken;
      return accessToken;

    } on FirebaseAuthException catch (error) {
      print(error.message);
      return null;
    }
  }

  Future<void> connectOneDrive(BuildContext context) async {
    print("hello onedrive user!");
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credentialGoogle = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await firebaseAuth.signOut();
    var data1 = await getAuthorizationCode();
    print(data1);
    if (data1 == null && data1 == "") {
      print("No se inicio sesion correctamente");
    }
    await firebaseAuth.signOut();

    var account = await firebaseAuth.signInWithCredential(credentialGoogle);

    if (account != null && account != "") {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (data1 != "" && data1 != null) {
          print("Se inicio sesion correctamente");

          var tokensend = await tokensend1(data1);

          if (tokensend != "") {
            print("Se obtuvo el token correctamente");
            Provider
                .of<MarkerProvider>(context, listen: false)
                .tokenOneDrive = true;
            Provider
                .of<MarkerProvider>(context, listen: false)
                .tokenonedrivestring = data1;
            isConectadoOneDrive = true;
          } else {
            Provider
                .of<MarkerProvider>(context, listen: false)
                .tokenOneDrive = false;
            Provider
                .of<MarkerProvider>(context, listen: false)
                .tokenonedrivestring = "";
            print("No se obtuvo el token correctamente");
          }
        }
      }
    }
  }

  Future<void> disconnectOneDrive(BuildContext context) async {
    print("hello");
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "oneDriveToken": "",
      });
    }

    Provider.of<MarkerProvider>(context, listen: false).tokenOneDrive = false;
    Provider.of<MarkerProvider>(context, listen: false).tokenonedrivestring = "";
    isConectadoOneDrive = false;
  }


  Future<void> getFilesOnedrive(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/drive/root/children'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Files: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> uploadFiletoOneDrive(io.File file17) async {

  }

  // conexion con dropbox login y logout con dropbox_client

  Future initDropbox() async {
    try {
      await Dropbox.init("appmovilesrealizado17", "2mo595er7yas01x", "ofyy6b5bjve5lfx");
      print("Inicio correcto de Dropbox");
    } catch (error) {
      print(error);
    }
  }

  //conectar con la cuenta de dropbox
  Future<void> connectDropbox() async {
    try {
      var dropbox = await Dropbox.authorize();

      var user = await Dropbox.getAccountName();
      print("Usuario de Dropbox: $user");

    } catch (error) {
      print(error);
    }
  }


  Future<void> disconnectDropbox() async {
    // Implementar desconexión con Dropbox
    print("dropbox");
    await Dropbox.unlink();
    isConectadoDropbox = false;
  }

  Future<void> connectGoogleDrive() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        isConectadoGoogleDrive = true;
      }
      // Ahora puedes usar driveApi para interactuar con Google Drive
    } catch (error) {
      print(error);
    }
  }


  Future<List<Map<String, Object?>>> getGoogleDriveFiles() async {
    GoogleSignInAccount? account = _googleSignIn.currentUser;
    if (account == null) {
      account = await _googleSignIn.signInSilently();
    }
    final authHeaders = await account!.authHeaders;
    final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
      AccessToken('Bearer', authHeaders['Authorization']!.split(' ').last, DateTime.now().add(Duration(hours: 1)).toUtc()),
      null,
      ['https://www.googleapis.com/auth/drive.file', 'https://www.googleapis.com/auth/drive']
    ));

    final driveApi = drive.DriveApi(authenticateClient);

    final archivos = await driveApi.files.list(q: 'mimeType != \'application/vnd.google-apps.folder\'', $fields: 'files(name, id, thumbnailLink, size, mimeType, createdTime)');

    return archivos.files!.map((file) => {'nombre': file.name, 'id': file.id, 'screenarchivo': file.thumbnailLink, 'size': file.size ?? '----', 'extension': file.mimeType, 'fecha': file.createdTime ?? "----", 'servicio': 'Google Drive'}).toList();
  }

  Future<void> uploadFile(bool uploadtoGoogleDrive, bool uploadtoOneDrive, bool uploadToDropbox, io.File file17) async {
    if (uploadtoGoogleDrive) {
      print('good');
      await uploadFiletoGoogleDrive(file17);
    }
    if (uploadtoOneDrive) {
      print('good12');
      await uploadFiletoOneDrive(file17);
    }
    if (uploadToDropbox) {
      print('good17');
    }
  }

  Future<void> uploadFiletoGoogleDrive(io.File file17) async {
    GoogleSignInAccount? account = _googleSignIn.currentUser;
      if (account == null) {
        account = await _googleSignIn.signInSilently();
      }
      final authHeaders = await account!.authHeaders;
      final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
        AccessToken('Bearer', authHeaders['Authorization']!.split(' ').last, DateTime.now().add(Duration(hours: 1)).toUtc()),
        null,
        ['https://www.googleapis.com/auth/drive.file', 'https://www.googleapis.com/auth/drive']
      ));

      final driveApi = drive.DriveApi(authenticateClient);

      var filetoUpload = drive.File();
      String fileName = file17.path.split("/").last;
      String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
      String extension = fileName.substring(fileName.lastIndexOf('.'));

      var search = await driveApi.files.list(q: "name contains '$baseName'");
      int count = search.files!.where((file) => file.name!.startsWith(baseName)).length;

      if (count > 0) {
        fileName = '$baseName(${count + 1})$extension';
      }

      filetoUpload.name = fileName;

      var media = drive.Media(await file17.openRead(), await file17.length());

      try {
        var result = await driveApi.files.create(filetoUpload, uploadMedia: media);
        print("Archivo subido correctamente: ${result.id}");
      } catch (error) {
        print("Error de lo siguiente: ${error}");
      }

  }

  Future<void> downloadFiletoGoogleDrive(String fileid17) async {
    GoogleSignInAccount? account = _googleSignIn.currentUser;
      if (account == null) {
        account = await _googleSignIn.signInSilently();
      }
      final authHeaders = await account!.authHeaders;
      final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
        AccessToken('Bearer', authHeaders['Authorization']!.split(' ').last, DateTime.now().add(Duration(hours: 1)).toUtc()),
        null,
        ['https://www.googleapis.com/auth/drive.file', 'https://www.googleapis.com/auth/drive']
      ));

      final driveApi = drive.DriveApi(authenticateClient);

      final fileMetaDato = await driveApi.files.get(fileid17) as drive.File;

      String fileName17 = fileMetaDato.name!;

      String extension = fileMetaDato.name!.split('/').last;

      drive.Media file = await driveApi.files.get(fileid17, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

      final carpetaarchivorealizado17 = await getExternalStorageDirectory();

      final saveFile = io.File('${carpetaarchivorealizado17!.path}/$fileName17.$extension');
      /* final taskId = await FlutterDownloader.enqueue(
        url: 'https://${saveFile.path}',
        savedDir: carpetaarchivorealizado17.path,
        fileName: fileName17,
        showNotification: true,
        openFileFromNotification: true,
      ); */

      List<int> dataStore = [];

      file.stream.listen((dato) {
        dataStore.insertAll(dataStore.length, dato);
      }, onDone: () async {
        saveFile.writeAsBytes(dataStore);
        print("Archivo descargado correctamente: ${saveFile.path}");
        OpenFile.open(saveFile.path);
      }, onError: (error) {
        print("Archivo subido correctamente: $error");
      });

  }

  Future<void> deleteGoogleDriveFile(String fileid17) async {
    GoogleSignInAccount? account = _googleSignIn.currentUser;
    if (account == null) {
      account = await _googleSignIn.signInSilently();
    }
    final authHeaders = await account!.authHeaders;
    final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
      AccessToken('Bearer', authHeaders['Authorization']!.split(' ').last, DateTime.now().add(Duration(hours: 1)).toUtc()),
      null,
      ['https://www.googleapis.com/auth/drive.file', 'https://www.googleapis.com/auth/drive']
    ));

    final driveApi = drive.DriveApi(authenticateClient);

    try {
      await driveApi.files.delete(fileid17);
      print("Archivo quitado correctamente 17");
    } catch (error17) {
      print("Error en lo siguiente: ${error17}");
    }

  }

  Future<void> disconnectGoogleDrive() async {
    await _googleSignIn.signOut();
    isConectadoGoogleDrive = false;
  }
}
