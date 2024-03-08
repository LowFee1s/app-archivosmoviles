import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constantes.dart';

class BienvenidaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Constantes.kcPrimaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Constantes.estadoBarraColor,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/img/logo.png", height: 210),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Constantes.textIntro,
                        style: TextStyle(
                          color: Constantes.kcBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                    TextSpan(
                        text: Constantes.textIntroDesc1,
                        style: TextStyle(
                            color: Constantes.kcDarkBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0)),
                    TextSpan(
                        text: Constantes.textIntroDesc2,
                        style: TextStyle(
                            color: Constantes.kcBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0)),
                  ])),
              SizedBox(height: size.height * 0.01),
              Text(
                Constantes.textChicoRegistro,
                style: TextStyle(color: Constantes.kcDarkGreyColor),
              ),
              SizedBox(height: size.height * 0.1),
              SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    result == null
                        ? Navigator.pushNamed(context, Constantes.InicioSesionNavegacion)
                        : Navigator.pushReplacementNamed(
                            context, Constantes.homeNavegacion);
                  },
                  child: Text(Constantes.textIniciar),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constantes.kcPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constantes.kcBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  onPressed: () {
                    result == null
                        ? Navigator.pushNamed(context, Constantes.InicioSesionNavegacion)
                        : Navigator.pushReplacementNamed(context, Constantes.homeNavegacion);
                  },
                  child: Text(
                    Constantes.textInicioSesion,
                    style: TextStyle(color: Constantes.kcBlackColor),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constantes.kcGreyColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                ),
              )
            ],
          ))),
    );
  }
}
