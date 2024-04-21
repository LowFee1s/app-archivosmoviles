
import 'package:appmovilesproyecto17/Pantallas/detallescuenta.dart';
import 'package:flutter/material.dart';

import '../Pantallas/archivos_page.dart';
import '../Pantallas/bienvenida_page.dart';
import '../Pantallas/home_page.dart';
import '../Pantallas/inicio_sesion.dart';
import '../Pantallas/perfil_page.dart';
import '../Pantallas/registro.dart';

class Navegacion {

  static Map<String, Widget Function(BuildContext)> routes = {
    //'/': (context) => BienvenidaPage(),
    '/iniciar-sesion': (context) => InicioSesion(),
    '/registro': (context) => Registro(),
    '/detallecuenta': (context) => Detallescuenta(),
    '/home': (context) => HomePage(onTabTapped: (index) {print(index);}),
    '/configuracion': (context) => SettingPage(),
    '/archivos': (context) => FilesPage(),
  };
}
