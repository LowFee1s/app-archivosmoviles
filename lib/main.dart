import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_authuser.dart';
import 'package:appmovilesproyecto17/Firebase/firebase_options.dart';
import 'package:appmovilesproyecto17/Pantallas/archivos_page.dart';
import 'package:appmovilesproyecto17/Pantallas/detallescuenta.dart';
import 'package:appmovilesproyecto17/Pantallas/inicio_sesion.dart';
import 'package:appmovilesproyecto17/Pantallas/perfil_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'Navegacion/MarkerProvider.dart';
import 'Navegacion/Menubar.dart';
import 'Navegacion/Navegacion.dart';
import 'Pantallas/bienvenida_page.dart';
import 'constantes.dart';
import 'Pantallas/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

  void refreshAccessToken() async {
    CloudServicios cloudServicios = CloudServicios();
    try {
      final GoogleSignInAccount? googleSignInAccount = await cloudServicios.google1SignIn.signInSilently();

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      // Actualizar el token de acceso en Firestore
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "usertokenGoogleDrive": googleSignInAuthentication.accessToken,
      });

      print('Token de acceso actualizado correctamente');

    } on FirebaseAuthException catch (error) {
      print(error.message);
    }
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constantes.titulo,
      navigatorKey: navigatorKey,
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
                future: _checarsirellenolosdatos(),
                builder: (BuildContext context,
                    AsyncSnapshot<bool> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(color: Colors.white, child: Center(child: CircularProgressIndicator()));
                      } else {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                            if (snapshot.data == true) {
                              return FutureBuilder(
                                  future: _checarSiestaconectadoIniciadoSesion(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(color: Colors.white, child: Center(child: CircularProgressIndicator()));
                                    } else {
                                      if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {

                                        CloudServicios cloudServicios = CloudServicios();
                                        User? user = FirebaseAuth.instance.currentUser;
                                        FirebaseAuthUsuario firebaseAuthUsuario = FirebaseAuthUsuario();
                                        /*
                                        FirebaseAuth.instance.authStateChanges().listen((User? user) {
                                          if (user == null) {
                                            print("El usuario ha cerrado sesion. ");
                                          } else {
                                            user.getIdToken(true).then((String? token) async {
                                              print("Este es el token nuevo: $token");
                                              if (user.providerData[0].providerId == "microsoft.com") {
                                                await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                                                  "useronedrivetoken": token,
                                                });
                                              }

                                              if (user.providerData[0].providerId == "google.com") {
                                                await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
                                                  "usertokenGoogleDrive": token,
                                                });
                                              }
                                            }).catchError((error) {
                                              print("Ocurrio algo inesperado: $error");
                                            });
                                          }
                                        });

                                         */

                                        if (snapshot.data != null) {
                                          if (snapshot.data!["usertokenGoogleDrive"] == "") {
                                            Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = false;
                                            cloudServicios.isConectadoGoogleDrive = false;
                                          } else {
                                            Provider.of<MarkerProvider>(context, listen: false).setisConnectedGoogleDrive = true;
                                            Provider.of<MarkerProvider>(context, listen: false).setusertokenGoogleDrive = snapshot.data!["usertokenGoogleDrive"];
                                            cloudServicios.isConectadoGoogleDrive = true;
                                            refreshAccessToken();
                                          }
                                          if (snapshot.data!["useroneDrivetoken"] == "") {
                                            Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoft = false;
                                            cloudServicios.isConectadoOneDrive = false;
                                          } else {
                                            Provider.of<MarkerProvider>(context, listen: false).setisConnectedMicrosoft = true;
                                            Provider.of<MarkerProvider>(context, listen: false).setusertokenOneDrive = snapshot.data!["useroneDrivetoken"];
                                            cloudServicios.isConectadoOneDrive = true;
                                          }
                                          if (user!.providerData[0].providerId != "microsoft.com" && user!.providerData[0].providerId != "google.com") {
                                            if (!(user!.emailVerified)) {
                                              return InicioSesion();
                                            }
                                          }
                                          if (user!.providerData[0].providerId == "microsoft.com") {
                                            return InicioSesion();
                                          }

                                          Provider.of<MarkerProvider>(context, listen: false).setnombreuser = user!.displayName!;
                                          Provider.of<MarkerProvider>(context, listen: false).setphotouser = user!.photoURL!;

                                        }

                                        return MainPage();

                                      }
                                    }
                                  }
                              );
                            } else {
                              return Detallescuenta();
                            }
                          }
                      }
                    }
                  );
                }
              }
            }
          }
      ),
      routes: Navegacion.routes,
    );
  }

  Future<Map<String, dynamic>> _checarSiestaconectadoIniciadoSesion() async {
    if (FirebaseAuth.instance.currentUser != null) {

      User? user = FirebaseAuth.instance.currentUser;

      IdTokenResult tokenResult = await user!.getIdTokenResult();
      DateTime expirationtoken = tokenResult.expirationTime!;
      print(tokenResult.expirationTime);
      DateTime dateTime = DateTime.now();

      if (dateTime.isAfter(expirationtoken)) {
        await user.getIdTokenResult(true);
        user.reload();
        print("El token se actualizo porque expiro del user. ");
      } else {
        print("El token todavia no expira del user. ");
      }

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

  Future<Map<String, dynamic>> _checarSiestaIniciadoSesionMicrosoft() async {
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

  Future<bool> _checarsirellenolosdatos() async {

    final user = await FirebaseAuth.instance.currentUser;
    if (user!.providerData[0].providerId == "microsoft.com") {
      return user != null && user.photoURL != "" && user.photoURL != null;
    }
    return user != null && user.displayName != null && user.photoURL != null;
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
      HomePage(key: ValueKey(_currentIndex), onTabTapped: onTabTapped),
      SettingPage(),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _children = [
        FilesPage(),
        HomePage(key: ValueKey(_currentIndex), onTabTapped: onTabTapped),
        SettingPage(),
      ];
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