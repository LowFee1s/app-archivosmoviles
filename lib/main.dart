import 'package:appmovilesproyecto17/Firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checarSiEstaLogin(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return snapshot.data != null ? HomePage() : BienvenidaPage();
            }
          }
        },
      ),
      routes: Navegacion.routes,
    );
  }

  Future<User?> _checarSiEstaLogin() async {
    return FirebaseAuth.instance.currentUser;
  }

}
