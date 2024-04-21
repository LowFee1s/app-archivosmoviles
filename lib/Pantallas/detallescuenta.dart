import 'dart:io';
import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:image_picker/image_picker.dart';

import '../constantes.dart';

class Detallescuenta extends StatefulWidget {

  @override
  _Detallescuentastate createState() => _Detallescuentastate();
}

class _Detallescuentastate extends State<Detallescuenta> {

  final TextEditingController usuarionamecontroller = TextEditingController();
  CloudServicios cloudServicios = CloudServicios();
  FirebaseAuthUsuario authUsuario = FirebaseAuthUsuario();
  XFile? _imageFile;

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

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Size size = MediaQuery.of(context).size;
    OutlineInputBorder(
      borderSide: BorderSide(color: Constantes.kcBordeColor, width: 3.0)
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.signOutAlt),
          onPressed: () async {
            cloudServicios.isConectadoGoogleDrive ? await authUsuario.signOutconGoogle() : await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed(Constantes.InicioSesionNavegacion);
          },
        ),
      ),
      backgroundColor: Constantes.kcPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Rellena tus datos",
                      style: TextStyle(
                        color: Constantes.kcBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ])),
            Text(
              "Ingresa los siguientes datos correctamente.",
              style: TextStyle(color: Constantes.kcDarkGreyColor),
            ),
            SizedBox(height: size.height * 0.05),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
            SizedBox(
              width: size.width * 0.8,
              child: TextFormField(
                  controller: usuarionamecontroller,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(21),
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  decoration: InputDecoration(
                    labelText: "Nombre de usuario",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      )),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: pickImageFromGallery,
                child: const Text("Selecciona una imagen"),
              ),
            ),
            _imageFile != null ? Center(
              child: Column(
                children: [
                  Text("Imagen seleccionada: "),
                  Image.file(File(_imageFile!.path), height: size.height * 0.15),
                ],
              ),
            ): Text("No se ha seleccionado ninguna imagen. "),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
            usuarionamecontroller.text.isNotEmpty && _imageFile != null ?
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {
                        try {
                          User? user = FirebaseAuth.instance.currentUser;
                          final userphoto = await uploadImageAndGetURL();
                          if (user != null) {
                            await user.updateProfile(displayName: usuarionamecontroller.text, photoURL: userphoto);
                            await user.reload();

                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);

                          }
                        } on FirebaseAuthException catch (error) {
                            print(error);
                        }
                      },
                child: Text(Constantes.textInicioSesion),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcPrimaryColor),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcDarkBlueColor),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              ),
            )
                :  SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {},
                child: Text("Enviar datos"),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcPrimaryColor),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              ),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
