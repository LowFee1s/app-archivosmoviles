import 'package:flutter/material.dart';

class MarkerProvider with ChangeNotifier {
  bool _tokenonedrive = false;
  String? _tokenonedrivestring = "";

  String? _filtroaplicado;
  String? _filtroaplicadorealizado;
  int _cantidadcamionesrealizado = 10;
  bool _filtroChecar = false;
  bool _filtrotipo = false;

  bool _botonmostrar = false;

  List<bool> _botoncardrealizado = [];
  Map<String, dynamic> _datosfirestore = {};
  Map<String, dynamic> get datosfirestore => _datosfirestore;
  Map<String, Future<String>> arrivalTime = {};
  Map<String, Future<String>> locationName = {};

  bool _botoncamiones = false;

  bool get botonmostrar => _botonmostrar;

  int get cantidadcamionesrealizado => _cantidadcamionesrealizado;

  bool getbotoncardrealizado(int index) => _botoncardrealizado[index];

  bool get botoncamiones => _botoncamiones;

  bool get tokenOneDrive => _tokenonedrive;
  bool get filtroTipo => _filtrotipo;

  String? get tokenonedrivestring => _tokenonedrivestring;

  String? get filtroaplicado => _filtroaplicado;

  set filtroChecar(bool valor) {
    _filtroChecar = valor;
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

  set tokenonedrivestring(String? valor) {
    _tokenonedrivestring = valor;
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
