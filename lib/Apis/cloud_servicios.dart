import 'dart:io' as io;

import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class CloudServicios {
  // OneDrive
  final onedrive = OneDrive(
    clientID: "ccbefcba-c090-4c47-a300-98bd8115f1e6",
    redirectURL: "com.movilesproyecto.appmovilesproyecto17://homepage",
  );

  bool isConectadoGoogleDrive = false;
  bool isConectadoOneDrive = false;
  bool isConectadoDropbox = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive'
    ],
  );

  Future<void> connectOneDrive(BuildContext context) async {

  }

  Future<void> disconnectOneDrive() async {
    await onedrive.disconnect();
    isConectadoOneDrive = false;
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

    final archivos = await driveApi.files.list($fields: 'files(name, id, thumbnailLink, size, mimeType, createdTime)');

    return archivos.files!.map((file) => {'nombre': file.name, 'id': file.id, 'screenarchivo': file.thumbnailLink, 'size': file.size ?? '----', 'extension': file.mimeType, 'fecha': file.createdTime ?? "----"}).toList();
  }

  Future<void> uploadFile(bool uploadtoGoogleDrive, bool uploadtoOneDrive, bool uploadToDropbox, io.File file17) async {
    if (uploadtoGoogleDrive) {
      print('good');
      await uploadFiletoGoogleDrive(file17);
    }
    if (uploadtoOneDrive) {
      print('good12');
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

  //checar
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

      List<int> dataStore = [];

      file.stream.listen((dato) {
        dataStore.insertAll(dataStore.length, dato);
      }, onDone: () {
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
