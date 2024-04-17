import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_options.dart';
import 'package:appmovilesproyecto17/Pantallas/archivos_page.dart';
import 'package:appmovilesproyecto17/Pantallas/perfil_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'Navegacion/MarkerProvider.dart';
import 'Navegacion/Menubar.dart';
import 'Navegacion/Navegacion.dart';
import 'Pantallas/bienvenida_page.dart';
import 'constantes.dart';
import 'Pantallas/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => MarkerProvider(), child: MyApp()));
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
              if (snapshot.data == null) {
                return BienvenidaPage();
              } else {
                return FutureBuilder(
                    future: _checarSiestaIniciadoSesion(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(color: Colors.white, child: Center(child: CircularProgressIndicator()));
                          } else {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              if (snapshot.data == null ||
                                  snapshot.data!["oneDriveToken"] == "") {
                                Provider.of<MarkerProvider>(context, listen: false).tokenOneDrive = false;
                                Provider.of<MarkerProvider>(context, listen: false).tokenonedrivestring = "";
                                return MainPage();
                              } else {
                                Provider.of<MarkerProvider>(context, listen: false).tokenOneDrive = true;
                                Provider.of<MarkerProvider>(context, listen: false).tokenonedrivestring = snapshot.data!["oneDriveToken"];
                                return MainPage();
                              }
                            }
                      }
                    }
                );
              }
            }
          }
        },
      ),
      routes: Navegacion.routes,
    );
  }

  Future<Map<String, dynamic>> _checarSiestaIniciadoSesion() async {
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (!documentSnapshot.exists) {
        return {"": ""};
      } else {
        return documentSnapshot.data() as Map<String, dynamic>;
      }
    } else {
      return {"": ""};
    }
  }

  Future<User?> _checarSiEstaLogin() async {
    return FirebaseAuth.instance.currentUser;
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      FilesPage(),
      HomePage(onTabTapped: onTabTapped),
      SettingPage(),
      // Agrega todas las pantallas que necesites
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: Menubar(
        index: _currentIndex,
        colors: [Colors.white, Colors.black, Colors.deepPurpleAccent],
        onTap: onTabTapped,
      ),
    );
  }
}