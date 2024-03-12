import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/Menubar.dart';
import 'package:appmovilesproyecto17/constantes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  User? user = FirebaseAuth.instance.currentUser;
  CloudServicios cloudServicios = new CloudServicios();

  final googleSignIn = GoogleSignIn.standard(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive',
    ],
  );


  @override
  void initState() {
    super.initState();
    cloudServicios.initDropbox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async {
              FirebaseAuthUsuario firebaseuser = new FirebaseAuthUsuario();
              await firebaseuser.signOutconGoogle();
              Navigator.pushReplacementNamed(context, Constantes.InicioSesionNavegacion);
            },
          )
        ],
        title: Text("Inicio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Constantes.ArchivosNavegacion);
                },
                child: Text('Ver archivos')
            ),
            Text(user!.email!),
            Text(user!.displayName!),
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
              radius: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Implementar conexión/desconexión con Dropbox
                      if (cloudServicios.isConectadoOneDrive) {
                        await cloudServicios.disconnectOneDrive();
                      } else {
                        await cloudServicios.connectOneDrive(context);
                      }
                  },
                  child: Text(cloudServicios.isConectadoOneDrive ? 'Desconectar OD' : 'OneDrive'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Implementar conexión/desconexión con Dropbox
                      if (cloudServicios.isConectadoDropbox) {
                        await cloudServicios.disconnectDropbox();
                      } else {
                        await cloudServicios.connectDropbox();
                      }
                  },
                  child: Text(cloudServicios.isConectadoDropbox ? 'Dropbox' : 'Desconectar db'),
                ),
                ElevatedButton(
                  onPressed: user!.providerData[0].providerId == "google.com" || cloudServicios.isConectadoGoogleDrive ? null
                   : () async {
                      // Implementar conexión/desconexión con Dropbox
                        if (cloudServicios.isConectadoGoogleDrive) {
                          await cloudServicios.disconnectGoogleDrive();
                        } else {
                          await cloudServicios.connectGoogleDrive();
                        }
                    },
                  child: Text('Google Drive'),
                ),
              ],
            ),

          ],
        ),
      ),
        bottomNavigationBar: Menubar(index: 1, colors: [Colors.deepPurple, Colors.black, Colors.white]),
    );
  }
}