import 'package:flutter/material.dart';


Future<void> showNotification(_scaffoldkey) async {

  _scaffoldkey.currentState.showSnackBar(
    SnackBar(
      content: Text("Archivo subido correctamente"),
      backgroundColor: Colors.green,
    ),
  );

}
