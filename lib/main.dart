import 'package:appmovilesproyecto17/firebase_options.dart';
import 'package:appmovilesproyecto17/inicio_sesion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'bienvenida_page.dart';
import 'constants.dart';
import 'home_page.dart';

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
      title: Constants.title,
      initialRoute: '/',
      routes: Navigate.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Navigate {

  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => BienvenidaPage(),
    '/iniciar-sesion': (context) => InicioSesion(),
    '/home': (context) => HomePage(),
  };
}
