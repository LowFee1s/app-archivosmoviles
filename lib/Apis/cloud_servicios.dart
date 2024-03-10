import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/cloudsearch/v1.dart';
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

    final archivos = await driveApi.files.list($fields: 'files(name, createdTime)');

    return archivos.files!.map((file) => {'nombre': file.name, 'fecha': file.createdTime ?? "----"}).toList();
  }

  Future<void> disconnectGoogleDrive() async {
    await _googleSignIn.signOut();
    isConectadoGoogleDrive = false;
  }
}
