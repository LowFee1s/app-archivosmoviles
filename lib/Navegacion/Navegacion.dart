
import 'dart:js';

import 'package:appmovilesproyecto17/Pantallas/archivos_page.dart';
import 'package:flutter/material.dart';

import '../Pantallas/bienvenida_page.dart';
import '../Pantallas/home_page.dart';
import '../Pantallas/inicio_sesion.dart';

class Navegacion {

  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => BienvenidaPage(),
    '/iniciar-sesion': (context) => InicioSesion(),
    '/home': (context) => HomePage(),
    '/archivos': (context) => FilesPage(),
  };
}
