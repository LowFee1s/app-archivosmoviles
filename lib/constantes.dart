import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constantes {
  //Colores (paleta de colores a utilizar)
  static const kcPrimaryColor = Color(0xFFFFFFFF);
  static const kcGreyColor = Color(0xFFEEEEEE);
  static const kcBlackColor = Color(0xFF000000);
  static const kcDarkGreyColor = Color(0xFF9E9E9E);
  static const kcDarkBlueColor = Color(0xFF6057FF);
  static const kcBordeColor = Color(0xFFEFEFEF);

  // Textos
  static const titulo = "Inicio de sesion con Google";
  static const textIntro = "Envia y recibe archivos \n en una sola app ";
  static const textIntrosubira = "Selecciona tu archivo \n a subir, ";
  static const textIntroDesc1 = "facil \n ";
  static const textIntroDescsubira = "dando click aqui! \n ";
  static const textIntroDesc2 = "para distintas apps!";
  static const textChicoRegistro = "Registrarte solo te toma 2 minutos!";
  static const textInicioSesion = "Inicia Sesion";
  static const textIniciar = "Comenzar";
  static const textInicioSesionTitulo = "Bienvenido de vuelta!";
  static const textInicioSesionTitulo1 = "Bienvenido de vuelta!,";
  static const textChicoInicioSesion = "Te hemos hechado de menos";
  static const textInicioSesionGoogle = "Iniciar Sesion con Google";
  static const textCuenta = "No tienes una cuenta?,  ";
  static const textRegistro = "Registrate aqui";
  static const textHome = "Inicio";

  // Navegacion
  static const InicioSesionNavegacion = '/iniciar-sesion';
  static const RegistroNavegacion = '/registro';
  static const DetallecuentaNavegacion = '/detallecuenta';
  static const ArchivosNavegacion = '/archivos';
  static const HomeNavegacion = '/home';
  static const PerfilNavegacion = '/configuracion';

  static const estadoBarraColor = SystemUiOverlayStyle(
      statusBarColor: Constantes.kcPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}