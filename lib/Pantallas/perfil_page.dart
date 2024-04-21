import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Apis/cloud_servicios.dart';
import '../constantes.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  User? user = FirebaseAuth.instance.currentUser;
  CloudServicios cloudServicios = CloudServicios();

  void initState() {
    super.initState();
    cloudServicios.isConectadoGoogleDrive = user!.providerData[0].providerId == "google.com";
    cloudServicios.isConectadoOneDrive;
  }

  @override
  Widget build(BuildContext context) {
    var isConectadoOneDrive = Provider.of<MarkerProvider>(context).tokenOneDrive;
    var isConnectedGoogleDriveFirebase = Provider.of<MarkerProvider>(context).isConnectedGoogleDriveFirebase;
    var isConnectedMicrosoftFirebase = Provider.of<MarkerProvider>(context).isConnectedMicrosoftFirebase;
    var isConnectedGoogleDrive = Provider.of<MarkerProvider>(context).isConnectedGoogleDrive;
    var isConnectedMicrosoft = Provider.of<MarkerProvider>(context).isConnectedMicrosoft;

    double screenwidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constrains) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Configuracion", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.deepPurpleAccent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Cerrar Sesion"),
                          content: Text("¿Estas seguro de que quieres cerrar sesion?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancelar"),
                            ),
                            TextButton(
                                onPressed: () async {
                                  FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                                  isConnectedGoogleDriveFirebase || isConnectedGoogleDrive ?
                                  await firebase.signOutconGoogle() : isConnectedMicrosoftFirebase || isConnectedMicrosoft ? await firebase.signOutconMicrosoft() : await FirebaseAuth.instance.signOut();
                                  Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = false;
                                  Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDriveFirebase = false;
                                  Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoftFirebase = false;
                                  Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoft = false;

                                  Navigator.pushReplacementNamed(
                                      context, Constantes.InicioSesionNavegacion);
                                },
                                child: Text("Confirmar"),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              // Aquí va el contenido que estará detrás del contenedor deslizable
              Container(
                color: Colors.deepPurpleAccent,
                child: Container(
                  margin: EdgeInsets.only(top: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // user image sin circle avatar
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user!.photoURL!),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user!.displayName!,
                            style: TextStyle(
                              fontSize: screenwidth * 0.05,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            user!.email!,
                            style: TextStyle(
                              fontSize: screenwidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.82,
                  // Tamaño inicial del contenedor deslizable
                  minChildSize: 0.82,
                  // Tamaño mínimo del contenedor deslizable
                  maxChildSize: 1,
                  // Tamaño máximo del contenedor deserializable
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
                                child: Container(
                                  margin: EdgeInsets.only(top: 21),
                                  width: 170,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(21),
                                  ),
                                ),
                              ),
                              SizedBox(height: 21),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: "Conexiones",
                                          style: TextStyle(
                                            color: Constantes.kcDarkBlueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenwidth * 0.07,
                                          )),
                                      TextSpan(
                                          text: "\nen tus servicios de almacenamiento",
                                          style: TextStyle(
                                              color: Constantes.kcBlackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenwidth * 0.05)),

                                    ])
                                ),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02),
                              // column del archivosscreen_boton agregar
                              Column(
                                children: [
                                  const SizedBox(height: 11),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 17, 30, 21),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("AllCloud (Local)",
                                                    style: TextStyle(
                                                        color: Constantes
                                                            .kcDarkGreyColor,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        fontSize: screenwidth * 0.04)
                                                ),
                                                SizedBox(width: 17),
                                                Icon(FontAwesomeIcons.cloud,
                                                    color: Colors.grey),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons
                                                      .checkCircle,
                                                  color: Colors.green,
                                                ),
                                                PopupMenuButton(
                                                  icon: Icon(Icons.more_vert,
                                                      color: Colors.black),
                                                  itemBuilder: (context) =>
                                                  [
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        leading: Icon(Icons.logout,
                                                            color: Colors.grey),
                                                        title: Text("Quitar cuenta",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        }
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 21),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Google Drive",
                                                    style: TextStyle(
                                                        color: Constantes
                                                            .kcDarkGreyColor,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        fontSize: screenwidth * 0.04)
                                                ),
                                                SizedBox(width: 17),
                                                Icon(FontAwesomeIcons
                                                    .googleDrive,
                                                    color: Colors.grey),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Icon(
                                                   isConnectedGoogleDriveFirebase || isConnectedGoogleDrive
                                                      ? FontAwesomeIcons
                                                      .checkCircle
                                                      : FontAwesomeIcons
                                                      .timesCircle,
                                                  color: isConnectedGoogleDriveFirebase || isConnectedGoogleDrive
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                PopupMenuButton(
                                                  icon: Icon(Icons.more_vert,
                                                      color: Colors.black),
                                                  itemBuilder: (context) =>
                                                  [
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        leading: Icon(
                                                          isConnectedGoogleDriveFirebase ? Icons.logout
                                                            :  isConnectedGoogleDrive
                                                                ? Icons.logout
                                                                : Icons.login,
                                                            color: isConnectedGoogleDriveFirebase ? Colors.grey
                                                                :  isConnectedGoogleDrive
                                                                ? Colors.red
                                                                : Colors.black),
                                                        title: Text(
                                                            isConnectedGoogleDriveFirebase ? "Quitar cuenta" :
                                                            isConnectedGoogleDrive
                                                                ? "Quitar cuenta"
                                                                : "Agregar cuenta",
                                                            style: isConnectedGoogleDriveFirebase ? TextStyle(color: Colors.grey) : isConnectedGoogleDrive
                                                                ? TextStyle(
                                                                color: Colors
                                                                    .black)
                                                                : TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        onTap: isConnectedGoogleDriveFirebase ? null : isConnectedGoogleDrive
                                                            ? () async {
                                                              FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                                                              var userGoogleDrive = await firebase.signOutAccount1ConnectWithGoogle();
                                                              if (userGoogleDrive != null){
                                                                Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = false;
                                                                Provider.of<MarkerProvider>(context, listen: false).setusertokenGoogleDrive = "";
                                                              }
                                                              setState(() {

                                                              });
                                                              Navigator.of(context).pop();
                                                            }
                                                            : () async {
                                                              FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                                                              var usertGoogleDrive = await firebase.signAccountConnectWithGoogle();
                                                              var datouser = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
                                                              if (usertGoogleDrive != null) {
                                                                Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = true;
                                                                if (datouser != null) {
                                                                  Provider.of<MarkerProvider>(context, listen: false).setusertokenGoogleDrive = datouser['usertokenGoogleDrive'];
                                                                }
                                                              }
                                                              setState(() {

                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                      ),
                                                    ),

                                                  ],
                                                )
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
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("OneDrive",
                                                    style: TextStyle(
                                                        color: Constantes
                                                            .kcDarkGreyColor,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        fontSize: screenwidth * 0.04)
                                                ),
                                                SizedBox(width: 17),
                                                Icon(FontAwesomeIcons.microsoft,
                                                    color: Colors.grey),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Icon(
                                                  isConnectedMicrosoftFirebase || isConnectedMicrosoft
                                                      ? FontAwesomeIcons
                                                      .checkCircle
                                                      : FontAwesomeIcons
                                                      .timesCircle,
                                                  color: isConnectedMicrosoftFirebase || isConnectedMicrosoft
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                PopupMenuButton(
                                                  icon: Icon(Icons.more_vert,
                                                      color: Colors.black),
                                                  itemBuilder: (context) =>
                                                  [
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        leading: Icon(
                                                            isConnectedMicrosoftFirebase ? Icons.logout
                                                            : isConnectedMicrosoft
                                                                ? Icons.logout
                                                                : Icons.login,
                                                            color: isConnectedMicrosoftFirebase ? Colors.grey : isConnectedMicrosoft
                                                                ? Colors.red
                                                                : Colors.black),
                                                        title: Text(
                                                            isConnectedMicrosoftFirebase ? "Quitar cuenta"
                                                            : isConnectedMicrosoft
                                                                ? "Quitar cuenta"
                                                                : "Agregar cuenta",
                                                            style: isConnectedMicrosoftFirebase ? TextStyle(color: Colors.grey)
                                                            : isConnectedMicrosoft
                                                                ? TextStyle(
                                                                color: Colors
                                                                    .black)
                                                                : TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        onTap: isConnectedMicrosoftFirebase ? null : isConectadoOneDrive
                                                            ? () {
                                                              cloudServicios.disconnectOneDrive(context);
                                                              Navigator.pop(context);
                                                            }
                                                            : () {
                                                              cloudServicios.connectOneDrive(context);
                                                              Navigator.pop(context);
                                                            },
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 21),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: "Desarrolladores",
                                          style: TextStyle(
                                            color: Constantes.kcDarkBlueColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenwidth * 0.07,
                                          )),
                                      TextSpan(
                                          text: "\nIntegrantes del Equipo 4",
                                          style: TextStyle(
                                              color: Constantes.kcBlackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenwidth * 0.05)),

                                    ])
                                ),
                              ),
                              const SizedBox(height: 21),
                              Text("1999491 - Francisco Javier Blas Garza", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                              Text("2109637 - Ángel Alfredo González Mora", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                              Text("2007777 - David Alejandro Garza Treviño", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                              Text("2001255 - Emilio Nicanor Hernández", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                              Text("1957773 - Liam Yahir De Anda Fang", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                              Text("1964534 - Jonathan Aldair Martínez González", style: TextStyle(fontSize: screenwidth * 0.04, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 21),
                            ],
                          ),
                        )
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}