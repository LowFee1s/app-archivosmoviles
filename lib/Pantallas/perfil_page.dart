import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
                  FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                  await firebase.signOutconGoogle();
                  Navigator.pushReplacementNamed(
                      context, Constantes.InicioSesionNavegacion);
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
                                                  cloudServicios
                                                      .isConectadoGoogleDrive
                                                      ? FontAwesomeIcons
                                                      .checkCircle
                                                      : FontAwesomeIcons
                                                      .timesCircle,
                                                  color: cloudServicios
                                                      .isConectadoGoogleDrive
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
                                                            cloudServicios
                                                                .isConectadoGoogleDrive
                                                                ? Icons.logout
                                                                : Icons.login,
                                                            color: cloudServicios
                                                                .isConectadoGoogleDrive
                                                                ? Colors.grey
                                                                : Colors.black),
                                                        title: Text(
                                                            cloudServicios
                                                                .isConectadoGoogleDrive
                                                                ? "Quitar cuenta"
                                                                : "Agregar cuenta",
                                                            style: cloudServicios
                                                                .isConectadoGoogleDrive
                                                                ? TextStyle(
                                                                color: Colors
                                                                    .grey)
                                                                : TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        onTap: cloudServicios
                                                            .isConectadoGoogleDrive
                                                            ? null
                                                            : () {
                                                          Navigator.pop(
                                                              context);
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
                                                  isConectadoOneDrive
                                                      ? FontAwesomeIcons
                                                      .checkCircle
                                                      : FontAwesomeIcons
                                                      .timesCircle,
                                                  color: isConectadoOneDrive
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
                                                            isConectadoOneDrive
                                                                ? Icons.logout
                                                                : Icons.login,
                                                            color: isConectadoOneDrive
                                                                ? Colors.red
                                                                : Colors.black),
                                                        title: Text(
                                                            isConectadoOneDrive
                                                                ? "Quitar cuenta"
                                                                : "Agregar cuenta",
                                                            style: isConectadoOneDrive
                                                                ? TextStyle(
                                                                color: Colors
                                                                    .black)
                                                                : TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        onTap: isConectadoOneDrive
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
                              Text("Opciones", style: TextStyle(
                                  color: Constantes.kcDarkBlueColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenwidth * 0.07
                              )),
                              Text("Proximamente", style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenwidth * 0.05
                              )),
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