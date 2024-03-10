import 'dart:io' as io;

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_onedrive/flutter_onedrive.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class CloudServicios {
  // OneDrive
  final onedrive = OneDrive(
    redirectURL: "your redirectURL",
    clientID: "your clientID",
  );

  bool isConectadoGoogleDrive = false;
  bool isConectadoOneDrive = false;
  bool isConectadoDropbox = false;

  // Dropbox
  final dropboxToken = "your dropbox token";
  http.Client? dropboxClient;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive'
    ],
  );

  Future<void> connectOneDrive() async {
    // Implementar conexión con OneDrive
  }

  Future<void> disconnectOneDrive() async {
    // Implementar desconexión con OneDrive
  }

  Future<void> connectDropbox() async {
    // Implementar conexión con Dropbox
  }

  Future<void> disconnectDropbox() async {
    // Implementar desconexión con Dropbox
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
      uploadFiletoGoogleDrive(file17.toString());
    }
    if (uploadtoOneDrive) {
      print('good12');
    }
    if (uploadToDropbox) {
      print('good17');
    }
  }

  Future<void> uploadFiletoGoogleDrive(String file17) async {
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
      filetoUpload.name = io.File(file17).path.split("/").last;
      filetoUpload.parents = ["appDataFolder"];

      var media = drive.Media(await io.File(file17).openRead(), await
      io.File(file17).length());

      try {
        var result = await driveApi.files.create(filetoUpload, uploadMedia: media);
        print("Archivo subido correctamente: ${result.id}");
      } catch (error) {
        print("Error de lo siguiente: ${error}");
      }

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
