
import 'package:flutter/material.dart';

import '../Pantallas/archivos_page.dart';
import '../Pantallas/bienvenida_page.dart';
import '../Pantallas/home_page.dart';
import '../Pantallas/inicio_sesion.dart';
import '../Pantallas/perfil_page.dart';

class Navegacion {

  static Map<String, Widget Function(BuildContext)> routes = {
    //'/': (context) => BienvenidaPage(),
    '/iniciar-sesion': (context) => InicioSesion(),
    '/home': (context) => HomePage(onTabTapped: (index) {print(index);}),
    '/configuracion': (context) => SettingPage(),
    '/archivos': (context) => FilesPage(),
  };
}
