import 'package:appmovilesproyecto17/firebase_options.dart';
import 'package:appmovilesproyecto17/Pantallas/inicio_sesion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Navegacion/Navegacion.dart';
import 'Pantallas/bienvenida_page.dart';
import 'constantes.dart';
import 'Pantallas/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constantes.titulo,
      initialRoute: '/',
      routes: Navegacion.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
