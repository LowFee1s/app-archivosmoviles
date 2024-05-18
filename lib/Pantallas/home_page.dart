import 'package:another_flushbar/flushbar.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:appmovilesproyecto17/Navegacion/Menubar.dart';
import 'package:appmovilesproyecto17/Pantallas/homepage_botonagregar.dart';
import 'package:appmovilesproyecto17/constantes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../constantes.dart';
import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'archivoscreen_botonagregar.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTabTapped;

  HomePage({Key? key, required this.onTabTapped}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  void onTabTapped(int index) {
    widget.onTabTapped(index);
  }

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
    cloudServicios.isConectadoOneDrive;
  }

  @override
  Widget build(BuildContext context) {


    final isConectadoOneDrive = Provider.of<MarkerProvider>(context).tokenOneDrive;
    final isConnectedGoogleDriveFirebase = Provider.of<MarkerProvider>(context).setisConnectedGoogleDriveFirebase = user!.providerData[0].providerId == "google.com";
    final isConnectedMicrosoftFirebase = Provider.of<MarkerProvider>(context).setisConnectedMicrosoftFirebase = user!.providerData[0].providerId == "microsoft.com";
    final isConnectedGoogleDrive = Provider.of<MarkerProvider>(context).isConnectedGoogleDrive;
    final isConnectedMicrosoft = Provider.of<MarkerProvider>(context).isConnectedMicrosoft;
    double screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    void showTopSnackBar11 (BuildContext context, String message, Color color) {
      Flushbar(
        titleText: Text("Archivo subido", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        backgroundColor: Colors.green,
        icon: Icon(Icons.check, color: Colors.white),
        messageColor: Colors.white,
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        shouldIconPulse: false,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        borderRadius: BorderRadius.circular(21),
        mainButton: TextButton(
          onPressed: () {
            widget.onTabTapped(0);
          },
          child: Text("Checar", style: TextStyle(color: Colors.white)),
        ),
        padding: EdgeInsets.all(21),
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        messageText: Text("El archivo se ha subido correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.032, color: Colors.white)),
        duration: Duration(seconds: 5),
      )..show(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Constantes.kcPrimaryColor,
            title: Text('All-Cloud'),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: Constantes.textInicioSesionTitulo1,
                                style: TextStyle(
                                  color: Constantes.kcBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05,
                                )),
                            TextSpan(
                                text: " ${user!.displayName!}" ?? "",
                                style: TextStyle(
                                    color: Constantes.kcDarkBlueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05)),
              
                          ])
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "Empieza ahora",
                                style: TextStyle(
                                  color: Constantes.kcDarkBlueColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.07,
                                )),
                            TextSpan(
                                text: "\nsubiendo un archivo a tu cuenta",
                                style: TextStyle(
                                    color: Constantes.kcBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.045)),
              
                          ])
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Container(
                      width: screenWidth,
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

                          var modalagregar = showModalBottomSheet(
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
                          modalagregar.then((value) {
                            if (value == true) {
                              showTopSnackBar11(context, "Archivo subido correcto", Colors.green);
                            }
                          });
                          },
                          child: Container(
                              child: Column(
                                children: [
                                 Icon(Icons.file_open_outlined,
                                          size: 30,
                                          color: Constantes.kcDarkGreyColor),
                                  SizedBox(height: 11),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  // tabla de las autenticaciones conectadas
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7, 0, 17, 0),
                      child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "Conexiones",
                                style: TextStyle(
                                  color: Constantes.kcDarkBlueColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.07,
                                )),
                            TextSpan(
                                text: "\nen tus servicios de almacenamiento",
                                style: TextStyle(
                                    color: Constantes.kcBlackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.045)),
              
                          ])
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // column del archivosscreen_boton agregar
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17, 17, 17, 21),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("All Cloud (Local)",
                                        style: TextStyle(
                                            color: Constantes.kcDarkGreyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.04)
                                    ),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.cloud, color: Colors.grey),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.checkCircle,
                                      color: Colors.green,
                                    ),
                                    //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 21),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Google Drive",
                                        style: TextStyle(
                                            color: Constantes.kcDarkGreyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.04)
                                    ),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.googleDrive, color: Colors.grey),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(

                                      Provider.of<MarkerProvider>(context).isConnectedGoogleDriveFirebase || isConnectedGoogleDrive || cloudServicios.isConectadoGoogleDrive || Provider.of<MarkerProvider>(context).isConnectedGoogleDrive ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.timesCircle,
                                      color: Provider.of<MarkerProvider>(context).isConnectedGoogleDriveFirebase || isConnectedGoogleDrive || cloudServicios.isConectadoGoogleDrive || Provider.of<MarkerProvider>(context).isConnectedGoogleDrive ? Colors.green : Colors.red,
                                    ),
                                    //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            /* const SizedBox(height: 21),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("All Cloud",
                                        style: TextStyle(
                                            color: Constantes.kcDarkGreyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0)
                                    ),
                                    SizedBox(width: 17),
                                    Icon(FontAwesomeIcons.cloud, color: Colors.grey),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      cloudServicios.isConectadoOneDrive ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.timesCircle,
                                      color: cloudServicios.isConectadoOneDrive ? Colors.green : Colors.red,
                                    ),
                                    //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ), */
                            const SizedBox(height: 21),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("OneDrive",
                                        style: TextStyle(
                                            color: Constantes.kcDarkGreyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.04)
                                    ),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.microsoft, color: Colors.grey),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Provider.of<MarkerProvider>(context).isConnectedMicrosoftFirebase || isConnectedMicrosoft || cloudServicios.isConectadoOneDrive || Provider.of<MarkerProvider>(context).isConnectedMicrosoft ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.timesCircle,
                                      color: Provider.of<MarkerProvider>(context).isConnectedMicrosoftFirebase || isConnectedMicrosoft || cloudServicios.isConectadoOneDrive ||  Provider.of<MarkerProvider>(context).isConnectedMicrosoft ? Colors.green : Colors.red,
                                    ),
                                    //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 9),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Constantes.kcPrimaryColor,
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          widget.onTabTapped(2);
                        },
                        child: Text("Ir a configuracion", style: TextStyle(fontSize: screenWidth * 0.04)),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: Menubar(index: 1, colors: [Colors.white, Colors.black, Colors.deepPurpleAccent]),
        );
      },
    );
  }
}