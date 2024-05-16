import 'package:flutter/material.dart';

class MarkerProvider with ChangeNotifier {
  bool _tokenonedrive = false;
  String? _usertokenOneDrive = "";
  String? _usertokenGoogleDrive = "";

  String? _filtroaplicado;
  String? _filtroaplicadorealizado;
  String? _usertipoDriveFile;
  int _cantidadcamionesrealizado = 10;
  bool _filtroChecar = false;
  bool _filtrotipo = false;

  bool _botonmostrar = false;
  String? _nombreuser = "";
  String? _photouser = "";

  bool _isConnectedGoogleDriveFirebase = false;
  bool _isConnectedMicrosoftFirebase = false;

  bool _moveGoogleDriveFile = false;
  bool _moveOneDriveFile = false;
  bool _moveAllCloudFile = false;

  bool _isConnectedGoogleDrive = false;
  bool _isConnectedMicrosoft = false;

  List<bool> _botoncardrealizado = [];
  Map<String, dynamic> _datosfirestore = {};
  Map<String, dynamic> get datosfirestore => _datosfirestore;
  Map<String, Future<String>> arrivalTime = {};
  Map<String, Future<String>> locationName = {};

  bool _botoncamiones = false;

  bool get botonmostrar => _botonmostrar;

  bool get isConnectedGoogleDriveFirebase => _isConnectedGoogleDriveFirebase;
  bool get isConnectedMicrosoftFirebase => _isConnectedMicrosoftFirebase;

  bool get moveGoogleDriveFile => _moveGoogleDriveFile;
  bool get moveOneDriveFile => _moveOneDriveFile;
  bool get moveAllCloudFile => _moveAllCloudFile;

  bool get isConnectedGoogleDrive => _isConnectedGoogleDrive;
  bool get isConnectedMicrosoft => _isConnectedMicrosoft;

  int get cantidadcamionesrealizado => _cantidadcamionesrealizado;

  bool getbotoncardrealizado(int index) => _botoncardrealizado[index];

  bool get botoncamiones => _botoncamiones;

  bool get tokenOneDrive => _tokenonedrive;
  bool get filtroTipo => _filtrotipo;

  String? get usertokenOneDrive => _usertokenOneDrive;
  String? get usertipoDriveFile => _usertipoDriveFile;
  String? get usertokenGoogleDrive => _usertokenGoogleDrive;

  String? get nombreuser => _nombreuser;
  String? get photouser => _photouser;
  String? get filtroaplicado => _filtroaplicado;

  set filtroChecar(bool valor) {
    _filtroChecar = valor;
    notifyListeners();
  }

  set setisConnectedGoogleDriveFirebase(bool valor) {
    _isConnectedGoogleDriveFirebase = valor;
    notifyListeners();
  }

  set setisConnectedMicrosoftFirebase(bool valor) {
    _isConnectedMicrosoftFirebase = valor;
    notifyListeners();
  }

  set setmoveGoogleDriveFile(bool valor) {
    _moveGoogleDriveFile = valor;
    notifyListeners();
  }

  set setmoveOneDriveFile(bool valor) {
    _moveOneDriveFile = valor;
    notifyListeners();
  }

  set settipoDriveFile(String valor) {
    _usertipoDriveFile = valor;
    notifyListeners();
  }

  set setmoveAllCloudFile(bool valor) {
    _moveAllCloudFile = valor;
    notifyListeners();
  }

  set setnombreuser(String valor) {
    _nombreuser = valor;
    notifyListeners();
  }

  set setphotouser(String valor) {
    _photouser = valor;
    notifyListeners();
  }

  set setisConnectedGoogleDrive(bool valor) {
    _isConnectedGoogleDrive = valor;
    notifyListeners();
  }

  set setisConnectedMicrosoft(bool valor) {
    _isConnectedMicrosoft = valor;
    notifyListeners();
  }


  set filtroTipo(bool valor) {
    _filtrotipo = valor;
    notifyListeners();
  }

  MarkerProvider() {
    _botoncardrealizado = List<bool>.filled(_cantidadcamionesrealizado, false);
  }

  set botoncamiones (bool valor11) {
    _botoncamiones = valor11;
    notifyListeners();
  }


  void setbotoncardrealizado(int index, bool valor17) {
    _botoncardrealizado[index] = valor17;
    notifyListeners();
  }

  set botonmostrar(bool valor1) {
    _botonmostrar = valor1;
    notifyListeners();
  }

  set setusertokenOneDrive(String? valor) {
    _usertokenOneDrive = valor;
    notifyListeners();
  }

  set setusertokenGoogleDrive(String? valor) {
    _usertokenGoogleDrive = valor;
    notifyListeners();
  }

  set filtroaplicadorealizado(String? valor17) {
    _filtroaplicadorealizado = valor17;
    notifyListeners();
  }

  set cantidadcamionesrealizado(int valor) {
    _cantidadcamionesrealizado = valor;
    notifyListeners();
  }

  set tokenOneDrive(bool token) {
    _tokenonedrive = token;
    notifyListeners();
  }

  void setDatosFirestore(Map<String, dynamic> datos) {
    _datosfirestore = datos;
    notifyListeners();
  }

  void quitarFiltro() {
    _filtroChecar = false;
    _filtrotipo = false;
    _filtroaplicadorealizado = null;
    _filtroaplicado = null;
    notifyListeners();
  }

}
