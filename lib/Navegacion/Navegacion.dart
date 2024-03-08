
import 'package:flutter/material.dart';

import '../bienvenida_page.dart';
import '../home_page.dart';
import '../inicio_sesion.dart';

class Navigate {

  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => BienvenidaPage(),
    '/iniciar-sesion': (context) => InicioSesion(),
    '/home': (context) => HomePage(),
  };
}
