import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:aad_oauth/model/config.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Firebase/firebase_authuser.dart';


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

  final GoogleSignIn google1SignIn = GoogleSignIn(
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
    final GoogleSignInAccount? googleSignInAccount = await google1SignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credentialGoogle = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

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
            isConectadoOneDrive = true;
          } else {
            Provider
                .of<MarkerProvider>(context, listen: false)
                .tokenOneDrive = false;
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
    isConectadoOneDrive = false;
  }

  Future<List<Map<String, Object?>>> getFilesOnedrive(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/drive/root/children'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var dato = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(dato['value']).where((
            file) => file['folder'] == null && file['file'] != null).map((
            file) {
          DateTime? createdTimeUtc = DateTime.tryParse(file['createdDateTime']);
          String createdTimeLocal = createdTimeUtc != null ? createdTimeUtc
              .toLocal().toString() : "----";

          return {
            'nombre': file['name'],
            'id': file['id'],
            //'screenfile': file['thumblink'],
            'size': file['size'] ?? "----",
            'extension':
            file['file'] != null ? file['file']['mimeType'] : "----",
            'fecha': createdTimeLocal,
            'servicio': "OneDrive",
          };
        }).toList();
      } else {
        throw Exception("Error al cargar los documento12. ");
      }
    } catch (error11) {
      FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
      CloudServicios cloudServicios = CloudServicios();
      var userOneDrive = await firebase.signOutConectionWithMicrosoft();
      cloudServicios.isConectadoOneDrive = false;
      print(error11);
      return [];
    }
  }

  Future<void> uploadFiletoOneDrive(io.File file17, String accesstoken) async {
    var fileName;
    var archivos = await getFilesOnedrive(accesstoken);
    var fileNametipoUser = basename(file17.path);
    fileNametipoUser = fileNametipoUser.substring(0, fileNametipoUser.lastIndexOf('.'));
    var onedrivearchivos = archivos.where((file) => (file['nombre'] as String).contains(fileNametipoUser)).toList();

    print(onedrivearchivos);
    if (onedrivearchivos.length <= 0) {
      fileName = basename(file17.path);
    } else {
      fileName = basename(file17.path).replaceFirst('.', ' (${onedrivearchivos.length + 1}).');
    }

    var url = Uri.parse('https://graph.microsoft.com/v1.0/me/drive/root:/$fileName:/content');

    // Lee el archivo como bytes
    var fileBytes = await file17.readAsBytes();

    // Crea la solicitud HTTP
    var request = http.Request('PUT', url)
      ..headers.addAll({
        'Authorization': 'Bearer $accesstoken',
        'Content-Type': 'application/octet-stream',
      })
      ..bodyBytes = fileBytes;

    // Envía la solicitud
    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Archivo subido correctamente');
    } else {
      print('Error al subir el archivo: ${response.statusCode}');
    }
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
      final GoogleSignInAccount? account = await google1SignIn.signIn();

      if (account != null) {
        isConectadoGoogleDrive = true;
      }
      // Ahora puedes usar driveApi para interactuar con Google Drive
    } catch (error) {
      print(error);
    }
  }


  String imagenselection(String file) {
    String extension = file;

    switch (extension) {
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.ppt':
        return 'application/vnd.ms-powerpoint';
      case '.pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case '.zip':
        return 'application/zip';
      case '.rar':
        return 'application/x-rar-compressed';
      case '.txt':
        return 'text/plain';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      case '.mp4':
        return 'video/mp4';
      case '.gif':
        return 'image/gif';
      case '.csv':
        return 'text/csv';
      case '.jpg':
        return 'image/jpg';
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      default:
        return 'text/plain';
    }
  }


  Future<void> uploadToAllcloud(String userId, io.File file17) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to the file you want to upload
    String fileName = file17.path.split("/").last;
    String baseName = fileName.substring(0, fileName.lastIndexOf('.'));
    String extension = fileName.substring(fileName.lastIndexOf('.'));

    // Create a reference to the user's folder in Firebase Storage
    final userFolderRef = storageRef.child(userId);

    // Check if a file with the same name already exists
    final existingFiles = (await userFolderRef.listAll()).items;
    final matchingFiles = existingFiles.where((file) => file.name.startsWith(baseName)).toList();

    if (matchingFiles.isNotEmpty) {
      // If a file with the same name exists, append a number to the filename
      fileName = '$baseName(${matchingFiles.length + 1})$extension';
    }
    var extensionfile = imagenselection(extension);

    final metadata = SettableMetadata(
      contentType: extensionfile,  // Replace 'image/jpeg' with the actual MIME type of your file
    );


    final fileRef = userFolderRef.child(fileName);

    // Upload the file to Firebase Storage
    try {
      await fileRef.putFile(file17, metadata);
      print("Archivo subido correctamente: ${fileRef.fullPath}");
    } catch (e) {
      print("Error de lo siguiente: ${e}");
    }
  }

  Future<void> downloadFileFromAllCloud(String userId, String fileName) async {
    // Create a reference to the file you want to download
    final storageRef = FirebaseStorage.instance.ref().child(userId).child(fileName);

    // Get the download URL
    final downloadUrl = await storageRef.getDownloadURL();

    // Use the download URL to download the file
    final response = await http.get(Uri.parse(downloadUrl));

    // Get the path to the device's external storage directory
    final directory = await getExternalStorageDirectory();

    // Create a new file in the external storage directory
    final file = File('${directory!.path}/$fileName');

    // Write the downloaded data to the file
    await file.writeAsBytes(response.bodyBytes);
    print("Archivo descargado correctamente: ${file.path}");
    await OpenFile.open(file.path);
  }

  Future<File> downloadFileFromAllCloud11(String userId, String fileName) async {
      // Create a reference to the file you want to download
      final storageRef = FirebaseStorage.instance.ref().child(userId).child(fileName);

      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Use the download URL to download the file
      final response = await http.get(Uri.parse(downloadUrl));

      // Get the path to the device's external storage directory
      final directory = await getExternalStorageDirectory();

      // Create a new file in the external storage directory
      final file = File('${directory!.path}/$fileName');

      // Write the downloaded data to the file
      await file.writeAsBytes(response.bodyBytes);
      print("Archivo descargado correctamente: ${file.path}");

      return file;

    }


  Future<List<Map<String, Object?>>> getAllcloudFiles(String userId) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref().child(userId);

    // List all files in the user's folder
    final listResult = await storageRef.listAll();

    // Map each item to a Map and return the list of maps
    final archivos = await Future.wait(listResult.items.map((item) async {
      final metadata = await item.getMetadata();
      final downloadUrl = await item.getDownloadURL();
      return {
        'nombre': item.name,
        'id': item.fullPath,
        'screenarchivo': downloadUrl,
        'size': metadata.size.toString(),
        'extension': metadata.contentType,
        'fecha': metadata.timeCreated.toString(),
        'servicio': 'AllCloud'
      };
    }));

    return archivos;
  }

  Future<void> downloadFileFromOneDrive(String accesstoken, String fileid17) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse('https://graph.microsoft.com/v1.0/me/drive/items/$fileid17/content'));
      request.headers.set('Authorization', 'Bearer $accesstoken');
      var response = await request.close();

      if (response.statusCode != 200) {
        print('Error downloading file: ${response.statusCode}');
        return;
      }

      var contentDisposition = response.headers.value('content-disposition');
      String fileName = "";

      if (contentDisposition != null) {
        var parts = contentDisposition.split(';');
        for (var part in parts) {
          var keyValue = part.trim().split('=');
          if (keyValue[0].toLowerCase() == 'filename') {
            fileName = keyValue[1].replaceAll('"', ''); // Remove quotes from filename
            break; // Stop after finding filename
          }
        }
      }

      var bytes = await consolidateHttpClientResponseBytes(response);

      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/$fileName');

      await file.writeAsBytes(bytes);

      print('Archivo descargado correctamente: ${file.path}');
      await OpenFile.open(file.path);

    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  Future<File?> downloadFileDetailFromOneDrive11(String accesstoken, String fileid17) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse('https://graph.microsoft.com/v1.0/me/drive/items/$fileid17/content'));
      request.headers.set('Authorization', 'Bearer $accesstoken');
      var response = await request.close();

      if (response.statusCode != 200) {
        print('Error downloading file: ${response.statusCode}');
        return null;
      }

      var contentDisposition = response.headers.value('content-disposition');
      String fileName = "";

      if (contentDisposition != null) {
        var parts = contentDisposition.split(';');
        for (var part in parts) {
          var keyValue = part.trim().split('=');
          if (keyValue[0].toLowerCase() == 'filename') {
            fileName = keyValue[1].replaceAll('"', ''); // Remove quotes from filename
            break; // Stop after finding filename
          }
        }
      }

      var bytes = await consolidateHttpClientResponseBytes(response);
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/$fileName');

      await file.writeAsBytes(bytes);

      print('Archivo descargado correctamente: ${file.path}');

      return file;

    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  Future<List<Map<String, Object?>>> getGoogleDriveFiles(String accesstoken) async {
    try {
      var datouser;
      GoogleSignInAccount? account = google1SignIn.currentUser;
      if (accesstoken == "") {
        if (account == null) {
          account = await google1SignIn.signInSilently();
        }
        final authHeaders = await account!.authHeaders;
        datouser = authHeaders['Authorization']!.split(' ').last;
      } else {
        datouser = accesstoken;
      }
      final authenticateClient = authenticatedClient(
          http.Client(), AccessCredentials(
          AccessToken('Bearer', datouser,
              DateTime.now().add(Duration(hours: 1)).toUtc()),
          null,
          [
            'https://www.googleapis.com/auth/drive.file',
            'https://www.googleapis.com/auth/drive'
          ]
      ));

      final driveApi = drive.DriveApi(authenticateClient);

      final archivos = await driveApi.files.list(
          q: 'mimeType != \'application/vnd.google-apps.folder\' and mimeType != \'application/vnd.google-apps.document\' and mimeType != \'application/vnd.google-apps.presentation\'',
          $fields: 'files(name, id, thumbnailLink, size, mimeType, createdTime)');

      return archivos.files!.map((file) =>
      {
        'nombre': file.name,
        'id': file.id,
        'screenarchivo': file.thumbnailLink,
        'size': file.size ?? '----',
        'extension': file.mimeType,
        'fecha': file.createdTime!.toLocal().toString() ?? "----",
        'servicio': 'Google Drive'
      }).toList();
    } catch (error11) {
      if (error11.toString().contains("invalid_token")) {
        FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
        CloudServicios cloudServicios = CloudServicios();
        var userGoogleDrive = await firebase.signOutAccount1ConnectWithGoogle();
        cloudServicios.isConectadoGoogleDrive = false;
      }
      return [];
    }
  }

  Future<void> uploadFile(String accesstokengoogledrive, String accesstokenonedrive, bool uploadtoGoogleDrive, bool uploadtoOneDrive, bool uploadToDropbox, io.File file17) async {
    if (uploadtoGoogleDrive) {
      print('good');
      await uploadFiletoGoogleDrive(file17, accesstokengoogledrive);
    }
    if (uploadtoOneDrive) {
      print('good12');
      await uploadFiletoOneDrive(file17, accesstokenonedrive);
    }
    if (uploadToDropbox) {
      print('good17');
      await uploadToAllcloud(FirebaseAuth.instance.currentUser!.uid, file17);
    }
  }

  Future<bool> shareFile(context, String nombrealmacenamiento, String idfile17, String file17, User user, String accesstokenonedrive, String accesstokengoogledrive) async {
    var documento;
    var dato = false;
    if (nombrealmacenamiento == "Google Drive") {
      documento = await downloadFileDetailtoGoogleDrive11(accesstokengoogledrive, idfile17);
    } else if (nombrealmacenamiento == "AllCloud") {
      documento = await downloadFileFromAllCloud11(user.uid, file17);
    } else if (nombrealmacenamiento == "OneDrive") {
      documento = await downloadFileDetailFromOneDrive11(accesstokenonedrive, idfile17);
    }

    if (documento != null) {

      while (!(await File(documento.path).exists())) {
        Future.delayed(Duration(seconds: 1));
      }

      final box = context.findRenderObject() as RenderBox?;

      await Share.shareFiles(['${documento.path}'], text: 'Archivo a compartir',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value) => dato = true);

      return true;
    }
    return false;
  }

  Future<void> moveFile(String nombrealmacenamiento, User user, String accesstokengoogledrive, String accesstokenonedrive, bool uploadtoGoogleDrive, bool uploadtoOneDrive, bool uploadToDropbox, String idfile17, String file17) async {
    var documento;
    var dato;

    if (nombrealmacenamiento == "Google Drive") {
      documento = await downloadFileDetailtoGoogleDrive11(accesstokengoogledrive, idfile17);
    } else if (nombrealmacenamiento == "AllCloud") {
      documento = await downloadFileFromAllCloud11(user.uid, file17);
    } else if (nombrealmacenamiento == "OneDrive") {
      documento = await downloadFileDetailFromOneDrive11(accesstokenonedrive, idfile17);
    }

    if (documento != null) {
      if (uploadtoGoogleDrive) {
        print('goodmove');
        await uploadFiletoGoogleDrive(documento, accesstokengoogledrive).then((value) => dato = true);
      }
      if (uploadtoOneDrive) {
        print('goodmove12');
        await uploadFiletoOneDrive(documento, accesstokenonedrive).then((value) => dato = true);
      }
      if (uploadToDropbox) {
        print('goodmove17');
        await uploadToAllcloud(
            FirebaseAuth.instance.currentUser!.uid, documento).then((value) => dato = true);
      }

      if (dato) {
        if (nombrealmacenamiento == "Google Drive") {
          await deleteGoogleDriveFile(idfile17, accesstokengoogledrive);
        }
        if (nombrealmacenamiento == "OneDrive") {
          await deletetoOneDriveFile(idfile17, accesstokenonedrive);
        }
        if (nombrealmacenamiento == "AllCloud") {
          await deletetoAllCloudFile(
              FirebaseAuth.instance.currentUser!.uid, file17);
        }
      }
    }
  }

  Future<void> uploadFiletoGoogleDrive(io.File file17, String accesstoken) async {
    var datouser;
    GoogleSignInAccount? account = google1SignIn.currentUser;
    if (accesstoken == "") {
      if (account == null) {
        account = await google1SignIn.signInSilently();
      }
      final authHeaders = await account!.authHeaders;
      datouser = authHeaders['Authorization']!.split(' ').last;
    } else {
      datouser = accesstoken;
    }
      final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
        AccessToken('Bearer', datouser, DateTime.now().add(Duration(hours: 1)).toUtc()),
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

  Future<void> deletetoAllCloudFile(String userId, String fileName) async {
    // Create a reference to the file you want to delete
    final storageRef = FirebaseStorage.instance.ref().child(userId).child(fileName);

    // Delete the file
    await storageRef.delete();

    print("Archivo quitado correctamente");
  }

  Future<void> deletetoOneDriveFile(String fileName, String accesstoken) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.deleteUrl(Uri.parse('https://graph.microsoft.com/v1.0/me/drive/items/$fileName'));
      request.headers.set('Authorization', 'Bearer $accesstoken');
      var response = await request.close();

      if (response.statusCode != 204) {
        print('Error eliminando el archivo: ${response.statusCode}');
        return;
      }

      print("Archivo quitado correctamente");
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  Future<void> downloadFiletoGoogleDrive(String accesstoken, String fileid17) async {
  var datouser;
  GoogleSignInAccount? account = google1SignIn.currentUser;
  if (accesstoken == ""){
    if (account == null) {
      account = await google1SignIn.signInSilently();
    }
    final authHeaders = await account!.authHeaders;
    datouser = authHeaders['Authorization']!.split(' ').last;
  } else {
    datouser = accesstoken;
  }
  final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
      AccessToken('Bearer', datouser, DateTime.now().add(Duration(hours: 1)).toUtc()),
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

  Future<File> downloadFileDetailtoGoogleDrive11(String accesstoken, String fileid17) async {
  var datouser;
  var documento;

  GoogleSignInAccount? account = google1SignIn.currentUser;
  if (accesstoken == ""){
    if (account == null) {
      account = await google1SignIn.signInSilently();
    }
    final authHeaders = await account!.authHeaders;
    datouser = authHeaders['Authorization']!.split(' ').last;
  } else {
    datouser = accesstoken;
  }
  final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
      AccessToken('Bearer', datouser, DateTime.now().add(Duration(hours: 1)).toUtc()),
      null,
      ['https://www.googleapis.com/auth/drive.file', 'https://www.googleapis.com/auth/drive']
    ));

    final driveApi = drive.DriveApi(authenticateClient);

    final fileMetaDato = await driveApi.files.get(fileid17) as drive.File;

    String fileName17 = fileMetaDato.name!.split('/').last;

    String extension = fileMetaDato.name!.substring(0, fileMetaDato.name!.lastIndexOf('.'));

    drive.Media file = await driveApi.files.get(fileid17, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    final carpetaarchivorealizado17 = await getExternalStorageDirectory();

    final saveFile = io.File('${carpetaarchivorealizado17!.path}/$fileName17');
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
      documento = saveFile;

    }, onError: (error) {
      print("Archivo subido correctamente: $error");
    });
    return saveFile;
}

  Future<void> deleteGoogleDriveFile(String fileid17, String accesstoken) async {
    var datouser;
    GoogleSignInAccount? account = google1SignIn.currentUser;
    if (accesstoken == "") {
      if (account == null) {
        account = await google1SignIn.signInSilently();
      }
      final authHeaders = await account!.authHeaders;
      datouser = authHeaders['Authorization']!.split(' ').last;
    } else {
      datouser = accesstoken;
    }
    final authenticateClient = authenticatedClient(http.Client(), AccessCredentials(
      AccessToken('Bearer', datouser, DateTime.now().add(Duration(hours: 1)).toUtc()),
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
    await google1SignIn.signOut();
    isConectadoGoogleDrive = false;
  }


}
