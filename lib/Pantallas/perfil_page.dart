import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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

  TextEditingController usuarioname = TextEditingController();
  XFile? _imageFile;
  CloudServicios cloudServicios = CloudServicios();

  void initState() {
    super.initState();
    cloudServicios.isConectadoGoogleDrive = user!.providerData[0].providerId == "google.com";
    cloudServicios.isConectadoOneDrive;
  }

  @override
  Widget build(BuildContext context) {
    var isConectadoOneDrive = Provider.of<MarkerProvider>(context).tokenOneDrive;
    var isConnectedGoogleDriveFirebase = user!.providerData[0].providerId == "google.com";
    var isConnectedMicrosoftFirebase = user!.providerData[0].providerId == "microsoft.com";
    var nombreuser = Provider.of<MarkerProvider>(context).nombreuser;
    var photouser = Provider.of<MarkerProvider>(context).photouser;
    var isConnectedGoogleDrive = Provider.of<MarkerProvider>(context).isConnectedGoogleDrive;
    var isConnectedMicrosoft = Provider.of<MarkerProvider>(context).isConnectedMicrosoft;

    double screenwidth = MediaQuery.of(context).size.width;


    Future<void> pickImageFromGallery() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
        // Actualiza el estado de tu aplicación si es necesario
        print("Se selecciono una imagen. ");
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    }

    Future<String> uploadImageAndGetURL() async {
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance.ref().child('user_images').child('${FirebaseAuth.instance.currentUser!.uid}.png');
        await ref.putFile(File(_imageFile!.path));
        return await ref.getDownloadURL();
      } else {
        throw Exception('No se seleccionó ninguna imagen.');
      }
    }


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
                          Column(
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
                                                              if (userGoogleDrive != null) {
                                                                Flushbar(
                                                                  titleText: Text("Sesion cerrada correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
                                                                  messageText: Text("Se quito la cuenta de Google correctamente. ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
                                                                  duration: Duration(seconds: 5),
                                                                  backgroundColor: Colors.red,
                                                                  borderRadius: BorderRadius.circular(21),
                                                                  maxWidth: MediaQuery.of(context).size.width * 1,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                                                  shouldIconPulse: false,
                                                                  margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                                                  padding: EdgeInsets.all(21),
                                                                  icon: Icon(Icons.close, color: Colors.white),
                                                                )..show(context);
                                                              }
                                                            }
                                                            : () async {
                                                              FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                                                              var usertGoogleDrive = await firebase.signAccountConnectWithGoogle();
                                                              var datouser = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();

                                                              if (datouser != null) {
                                                                Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = true;
                                                                Provider.of<MarkerProvider>(context, listen: false).setusertokenGoogleDrive = datouser['usertokenGoogleDrive'];
                                                              }

                                                              setState(() {

                                                              });
                                                              Navigator.of(context).pop();

                                                              if (datouser != null) {

                                                                Flushbar(
                                                                  titleText: Text("Inicio de sesion correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
                                                                  messageText: Text("Se conecto la cuenta de Google correctamente. ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
                                                                  duration: Duration(seconds: 5),
                                                                  backgroundColor: Colors.green,
                                                                  borderRadius: BorderRadius.circular(21),
                                                                  maxWidth: MediaQuery.of(context).size.width * 1,
                                                                  flushbarPosition: FlushbarPosition.TOP,
                                                                  dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                                                  shouldIconPulse: false,
                                                                  margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                                                  padding: EdgeInsets.all(21),
                                                                  icon: Icon(FontAwesomeIcons.check, color: Colors.white),
                                                                )..show(context);

                                                              }
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
                                                  isConnectedMicrosoftFirebase ||  Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                      ? FontAwesomeIcons
                                                      .checkCircle
                                                      : FontAwesomeIcons
                                                      .timesCircle,
                                                  color: isConnectedMicrosoftFirebase ||  Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                PopupMenuButton(
                                                  icon: Icon(Icons.more_vert,
                                                      color: Colors.black),
                                                  itemBuilder: (context) =>
                                                  [
                                                    PopupMenuItem(
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                                          foregroundColor: MaterialStatePropertyAll(Colors.transparent),
                                                          elevation: MaterialStatePropertyAll(0),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              isConnectedMicrosoftFirebase ? Icons.logout
                                                              :   Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                                  ? Icons.logout
                                                                  : Icons.login,
                                                              color: isConnectedMicrosoftFirebase ? Colors.grey :   Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                                  ? Colors.red
                                                                  : Colors.black),
                                                            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                                            Text(
                                                              isConnectedMicrosoftFirebase ? "Quitar cuenta"
                                                            :   Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                                ? "Quitar cuenta"
                                                                : "Agregar cuenta",
                                                            style: isConnectedMicrosoftFirebase ? TextStyle(color: Colors.grey)
                                                            :  Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                                ? TextStyle(
                                                                color: Colors
                                                                    .black)
                                                                : TextStyle(
                                                                color: Colors
                                                                    .black)),]),
                                                        onPressed: isConnectedMicrosoftFirebase ? null :  Provider.of<MarkerProvider>(context).isConnectedMicrosoft
                                                            ? () async {
                                                                FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                                                                var userOneDrive = await firebase.signOutConectionWithMicrosoft();
                                                                if (userOneDrive != null){
                                                                  Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoft = false;
                                                                  Provider.of<MarkerProvider>(context, listen: false).setusertokenOneDrive = "";
                                                                }
                                                                setState(() {

                                                                });
                                                                Navigator.of(context).pop();
                                                                if (userOneDrive != null) {
                                                                  Flushbar(
                                                                    titleText: Text("Sesion cerrada correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
                                                                    messageText: Text("Se quito la cuenta de microsoft correctamente. ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
                                                                    duration: Duration(seconds: 5),
                                                                    backgroundColor: Colors.red,
                                                                    borderRadius: BorderRadius.circular(21),
                                                                    maxWidth: MediaQuery.of(context).size.width * 1,
                                                                    flushbarPosition: FlushbarPosition.TOP,
                                                                    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                                                    shouldIconPulse: false,
                                                                    margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                                                    padding: EdgeInsets.all(21),
                                                                    icon: Icon(Icons.close, color: Colors.white),
                                                                  )..show(context);
                                                                }
                                                            }
                                                            : () {
                                                                //await firebase.startAuthorization();
                                                                Navigator.of(context).pop();

                                                                showCupertinoModalPopup(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return dialogdato();
                                                                    }
                                                                );

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

class dialogdato extends StatefulWidget {
  @override
  _dialogdato createState() => _dialogdato();
}
class _dialogdato extends State<dialogdato> {

  TextEditingController username = TextEditingController();
  bool isloading = false;
  TextEditingController password = TextEditingController();


  String? validateEmail(String? value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regex = RegExp(pattern);
    return (!regex.hasMatch(value!)) ? 'Ingrese un correo electrónico válido' : null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de sesion"),
      ),
      body: Container(
          child: Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network("https://pngimg.com/uploads/microsoft/microsoft_PNG10.png", height: 30,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Text("Bienvenido!, Inicia sesion", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04) ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                Text("*Ingresa tu cuenta institucional, personal o empresarial para hacer la conexion*", textAlign: TextAlign.center, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03, color: Colors.grey) ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ingresa tu correo',
                  ),
                  controller: username,
                  validator: validateEmail,
                  onChanged: (value) {
                    // Guarda el email en alguna variable
                    setState(() {
                      username.text = value;
                    });
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  controller: password,
                  obscureText: true,
                  onChanged: (value) {
                    // Guarda la contraseña en alguna variable
                    setState((){
                      password.text = value;
                    });
                },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                    onPressed: username.text.isNotEmpty && password.text.isNotEmpty ? () async {
                      setState(() {
                        isloading = true;
                      });
                      // Aquí puedes usar las variables del email y la contraseña\
                      FirebaseAuthUsuario firebase = FirebaseAuthUsuario();
                      User? user = FirebaseAuth.instance.currentUser;
                      var usertOneDrive = username.text != "" && password.text != "" ? await firebase.signInConectionWithMicrosoft(username.text, password.text) : null;

                      var datouser = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
                      if (usertOneDrive != null) {
                        username.text = "";
                        password.text = "";

                        Navigator.of(context).pop();
                        Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoft = true;
                        Provider.of<MarkerProvider>(context, listen: false).setusertokenOneDrive = datouser['useroneDrivetoken'];

                        Flushbar(
                          titleText: Text("Inicio de sesion correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
                          messageText: Text("Se conecto la cuenta de microsoft correctamente. ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.green,
                          borderRadius: BorderRadius.circular(21),
                          maxWidth: MediaQuery.of(context).size.width * 1,
                          flushbarPosition: FlushbarPosition.TOP,
                          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                          shouldIconPulse: false,
                          margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                          padding: EdgeInsets.all(21),
                          icon: Icon(FontAwesomeIcons.check, color: Colors.white),
                        )..show(context);

                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                content: Column(
                                  children: [
                                    Icon(Icons.error, color: Colors.red, size: 70),
                                    Text(textAlign: TextAlign.center, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03, fontWeight: FontWeight.w700), "No se encontro ninguna cuenta con los datos ingresados. Favor de verificar los datos e intentar de nuevo. "),
                                  ],
                                ),
                              );
                            }
                        );
                      }
                      setState(() {
                        isloading = false;
                      });
                    } : null,
                    child: isloading ? CircularProgressIndicator() : Text("Iniciar sesion")
                ),
              ],
            ),
          ),
      ),
    );
  }
}