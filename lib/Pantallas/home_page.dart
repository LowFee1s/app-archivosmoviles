import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/Menubar.dart';
import 'package:appmovilesproyecto17/Pantallas/homepage_botonagregar.dart';
import 'package:appmovilesproyecto17/constantes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constantes.dart';
import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'archivoscreen_botonagregar.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constantes.kcPrimaryColor,
        title: Text('All-Cloud'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              FirebaseAuthUsuario firebase = new FirebaseAuthUsuario();
              await firebase.signOutconGoogle();
              Navigator.pushReplacementNamed(context, Constantes.InicioSesionNavegacion);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 17, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Constantes.textInicioSesionTitulo1,
                        style: TextStyle(
                          color: Constantes.kcBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        )),
                    TextSpan(
                        text: " ${user!.displayName!}" ?? "",
                        style: TextStyle(
                            color: Constantes.kcDarkBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 21.0)),

                  ])
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Empieza ahora",
                        style: TextStyle(
                          color: Constantes.kcDarkBlueColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 31.0,
                        )),
                    TextSpan(
                        text: "\nsubiendo un archivo a tu cuenta",
                        style: TextStyle(
                            color: Constantes.kcBlackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 21.0)),

                  ])
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                      style: BorderStyle.solid,
                      width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(
                            Colors.transparent)),
                    onPressed: ()  {

                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: AgregarButtonHome(),
                          ),
                        );
                      });

                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                      child: Container(
                        child: Column(
                          children: [
                           Icon(Icons.file_open_outlined,
                                    size: 40,
                                    color: Constantes.kcDarkGreyColor),
                            SizedBox(height: 21),
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Subir archivo",
                                      style: TextStyle(
                                        color: Constantes.kcDarkGreyColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                      )),
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),/*Center(
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

      ), */
        bottomNavigationBar: Menubar(index: 1, colors: [Colors.white, Colors.black, Colors.deepPurpleAccent]),
    );
  }
}