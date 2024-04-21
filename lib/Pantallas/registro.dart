import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Pantallas/detallescuenta.dart';
import 'package:appmovilesproyecto17/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Navegacion/MarkerProvider.dart';
import '../constantes.dart';

class Registro extends StatelessWidget {

  final TextEditingController correocontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  String? validateEmail(String? value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regex = RegExp(pattern);
    return (!regex.hasMatch(value!)) ? 'Ingrese un correo electrónico válido' : null;
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
      backgroundColor: Constantes.kcPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Registrate",
                      style: TextStyle(
                        color: Constantes.kcBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ])),
            Text(
              "Para disfrutar de la app. No te toma mas de 2 minutos",
              style: TextStyle(color: Constantes.kcDarkGreyColor),
            ),
            SizedBox(height: size.height * 0.05),
            GoogleSignIn(),
            MicrosoftSignIn(),
            buildRowDivider(size: size),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
            SizedBox(
              width: size.width * 0.8,
              child: TextFormField(
                  controller: correocontroller,
                  validator: validateEmail,
                  decoration: InputDecoration(
                    labelText: "Correo Electronico",
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      )),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextFormField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  suffixIcon: Padding(
                    child: FaIcon(
                      FontAwesomeIcons.eye,
                      size: 15,
                    ),
                    padding: EdgeInsets.only(top: 15, left: 15),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
            correocontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty ?
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    final credenciales = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: correocontroller.text, password: passwordcontroller.text
                    );

                    User? user = FirebaseAuth.instance.currentUser;

                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user!.uid)
                        .set({
                      "useridGoogleDrive": "",
                      "useremailGoogleDrive": "",
                      "usertokenGoogleDrive": "",
                      "useroneDriveToken": "",
                    });


                    if (credenciales != null) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Detallescuenta()), (route) => false);
                    }

                  } on FirebaseAuthException catch (error) {
                    if (error.code == 'user-not-found') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("No se encontro ningun usuario con este correo y contraseña. \nPor favor verifica o crea una cuenta. ", style: TextStyle(fontWeight: FontWeight.w800)),
                                ],
                              ),
                            );
                          }
                      );
                    } else if (error.code == 'invalid-email') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("El correo proporcionado no es correcto. \nPor favor verifica los datos. ", style: TextStyle(fontWeight: FontWeight.w800)),
                                ],
                              ),
                            );
                          }
                      );
                    } else if (error.code == 'wrong-password') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("La contraseña ingresado no coincide con el correo proporcionado. \nPor favor verifica o crea una cuenta. ", style: TextStyle(fontWeight: FontWeight.w800)),
                                ],
                              ),
                            );
                          }
                      );
                    }
                  }
                },
                child: Text("Registrar"),
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
                child: Text("Registrar"),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcPrimaryColor),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Ya tienes cuenta?, ",
                      style: TextStyle(
                        color: Constantes.kcDarkGreyColor,
                      )),

                ])),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Constantes.InicioSesionNavegacion);
                },
                child: Text(
                    "Inicia sesion aqui",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constantes.kcDarkBlueColor,
                    )),
            )
          ],
        ),
      ),
    );
  }
}


Widget buildRowDivider({required Size size}) {
  return SizedBox(
    width: size.width * 0.8,
    child: Row(children: <Widget>[
      Expanded(child: Divider(color: Constantes.kcDarkGreyColor)),
      Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            "O",
            style: TextStyle(color: Constantes.kcDarkGreyColor),
          )),
      Expanded(child: Divider(color: Constantes.kcDarkGreyColor)),
    ]),
  );
}


class MicrosoftSignIn extends StatefulWidget {
  MicrosoftSignIn({Key? key}) : super(key: key);

  @override
  _MicrosoftSignInState createState() => _MicrosoftSignInState();
}

class _MicrosoftSignInState extends State<MicrosoftSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  !isLoading? SizedBox(
      width: size.width * 0.8,
      child: OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.microsoft),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          FirebaseAuthUsuario firebasedato = new FirebaseAuthUsuario();
          try {
            var usermicrosoft = await firebasedato.signInwithMicrosoft();
            User? user = FirebaseAuth.instance.currentUser;

            var datouser = await FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .get();

            if (datouser['usertokenGoogleDrive'] != "") {
              Provider.of<MarkerProvider>(context, listen: false).setusertokenGoogleDrive = datouser['usertokenGoogleDrive'];
              Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = true;
            }

            if (usermicrosoft != null && usermicrosoft != "") {

              var usernameaccount = FirebaseAuth.instance.currentUser!.photoURL;
              Provider.of<MarkerProvider>(context, listen: false).setusertokenOneDrive = usermicrosoft;

              if (usernameaccount != null && usernameaccount != "") {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Detallescuenta()), (route) => false);
              }
            }
          } catch(e){
            if(e is FirebaseAuthException){
              showMessage(e.message!);
            }
          }
          setState(() {
            isLoading = false;
          });
        },
        label: Text(
          "Registro con Microsoft",
          style: TextStyle(
              color: Constantes.kcBlackColor, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(Constantes.kcGreyColor),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
      ),
    ) : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  !isLoading? SizedBox(
      width: size.width * 0.8,
      child: OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.google),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          FirebaseAuthUsuario firebasedato = new FirebaseAuthUsuario();
          try {
            await firebasedato.signInWithGoogle();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
          } catch(e){
            if(e is FirebaseAuthException){
              showMessage(e.message!);
            }
          }
          setState(() {
            isLoading = false;
          });
        },
        label: Text(
          "Registro con Google",
          style: TextStyle(
              color: Constantes.kcBlackColor, fontWeight: FontWeight.bold),
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(Constantes.kcGreyColor),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
      ),
    ) : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
