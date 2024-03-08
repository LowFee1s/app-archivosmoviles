import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../constantes.dart';

class InicioSesion extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = OutlineInputBorder(
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
                      text: Constantes.textInicioSesionTitulo,
                      style: TextStyle(
                        color: Constantes.kcBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ])),
            Text(
              Constantes.textChicoInicioSesion,
              style: TextStyle(color: Constantes.kcDarkGreyColor),
            ),
            SizedBox(height: size.height * 0.05),
            GoogleSignIn(),
        /*    buildRowDivider(size: size),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      enabledBorder: border,
                      focusedBorder: border)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  enabledBorder: border,
                  focusedBorder: border,
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
            SizedBox(
              width: size.width * 0.8,
              child: OutlinedButton(
                onPressed: () async {},
                child: Text(Constantes.textInicioSesion),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcPrimaryColor),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Constantes.kcBlackColor),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              ),
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: Constantes.textCuenta,
                      style: TextStyle(
                        color: Constantes.kcDarkGreyColor,
                      )),
                  TextSpan(
                      text: Constantes.textRegistro,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constantes.kcDarkBlueColor,
                      )),
                ])),*/
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
            Navigator.pushNamedAndRemoveUntil(context, Constantes.HomeNavegacion, (route) => false);
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
          Constantes.textInicioSesionGoogle,
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