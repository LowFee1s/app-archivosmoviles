import 'dart:io';

import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constantes.dart';

class AgregarButton extends StatefulWidget {
  @override
  _AgregarButtonState createState() => _AgregarButtonState();
}

class _AgregarButtonState extends State<AgregarButton> {
  bool _fileselected = false;
  bool uploadtoGoogleDrive = false;
  final GoogleSignIn googlesignin = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive'
    ],
  );
  bool uploadtoOneDrive = false;
  bool uploadToDropbox = false;
  bool _selectionarchivo = false;
  CloudServicios servicios = new CloudServicios();
  File? _selectedFile;

  void iniciararchivo() async {
    GoogleSignInAccount? account = await googlesignin.signInSilently();
    if (account != null) {
      servicios.isConectadoGoogleDrive = true;
    }
  }

  @override
  void initState() {
    super.initState();
    iniciararchivo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Icon imagenselection(String file) {
    String extension = file;

    switch (extension) {
      case '.pdf':
        return Icon(FontAwesomeIcons.filePdf, color: Colors.red, size: 49);
      case '.doc':
      case '.docx':
        return Icon(FontAwesomeIcons.fileWord, color: Colors.blue, size: 49);
      case '.xls':
      case '.xlsx':
        return Icon(FontAwesomeIcons.fileExcel, color: Colors.green, size: 49);
      case '.ppt':
      case '.pptx':
        return Icon(FontAwesomeIcons.filePowerpoint,
            color: Colors.orange, size: 49);
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icon(FontAwesomeIcons.fileImage, color: Colors.purple, size: 49);
      default:
        return Icon(FontAwesomeIcons.file, color: Colors.grey, size: 49);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                      ),
                      child: Container(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 41),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: _fileselected
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                _fileselected
                    ? Container(
                        child: Column(
                          children: [
                            Text("Nombre del Archivo: ",
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            Text(
                                textAlign: TextAlign.center,
                                _selectedFile!.path.split('/').last,
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        imagenselection(path
                                            .extension(_selectedFile!.path)
                                            .toLowerCase()),
                                        Text(
                                            "${path.extension(_selectedFile!.path)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          textAlign: TextAlign.center,
                                          "Tamaño del archivo: \n ${formatBytes(_selectedFile!.lengthSync())}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 17),
                                      Text(
                                          textAlign: TextAlign.center,
                                          "Fecha del archivo: \n ${DateFormat('yyyy:MM:dd - kk:mm:ss').format(DateTime.parse(_selectedFile!.lastModifiedSync().toString()))}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text("Selecciona el/los servicios para el archivo:", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.deepPurpleAccent)),
                                const SizedBox(height: 11),
                                Padding(
                                  padding: const EdgeInsets.all(21),
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        title: Row(
                                          children: [
                                            Text('Google Drive'),
                                            SizedBox(width: 17),
                                            Icon(FontAwesomeIcons.googleDrive),
                                          ],
                                        ),
                                        value: uploadtoGoogleDrive,
                                        onChanged: servicios.isConectadoGoogleDrive ? (bool? value) {
                                          setState(() {
                                            uploadtoGoogleDrive = value!;
                                          });
                                        } : null
                                      ),
                                    /*  CheckboxListTile(
                                        title: Row(
                                          children: [
                                            Text('All Cloud'),
                                            SizedBox(width: 17),
                                            Icon(FontAwesomeIcons.cloud),
                                          ],
                                        ),
                                        value: uploadtoOneDrive,
                                        onChanged: servicios.isConectadoOneDrive ? (bool? value) {
                                          setState(() {
                                            uploadtoOneDrive = value!;
                                          });
                                        } : null
                                      ), */
                                      CheckboxListTile(
                                        title: Row(
                                          children: [
                                            Text('One Drive'),
                                            SizedBox(width: 17),
                                            Icon(FontAwesomeIcons.cloud),
                                          ],
                                        ),
                                        value: uploadToDropbox,
                                        onChanged: servicios.isConectadoDropbox ? (bool? value) {
                                          setState(() {
                                            uploadToDropbox = value!;
                                          });
                                        } : null
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      foregroundColor: Constantes.kcPrimaryColor,
                                      side: BorderSide.none,
                                    ),
                                    onPressed: uploadtoGoogleDrive || uploadtoOneDrive || uploadToDropbox ? () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return FutureBuilder(
                                            future: servicios.uploadFile(uploadtoGoogleDrive, uploadtoOneDrive, uploadToDropbox, _selectedFile!),
                                            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return AlertDialog(
                                                  content: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      CircularProgressIndicator(),
                                                      SizedBox(width: 21),
                                                      Text("Subiendo archivo....", style: TextStyle(fontWeight: FontWeight.w800)),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                if (snapshot.error != null) {
                                                  // Manejar error aquí
                                                  return Text('Error: ${snapshot.error}');
                                                } else {
                                                  // Si la carga fue exitosa, cierra el diálogo
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();

                                                  return Container();
                                                }
                                              }
                                            },
                                          );
                                        },
                                      );
                                    } : null,
                                    child: Text("Subir Archivos"),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(17, 17, 17, 140),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _selectionarchivo ? Colors.white : Colors.grey.withOpacity(0.7),
                                style: BorderStyle.solid,
                                width: _selectionarchivo ? 1 : 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: _selectionarchivo ? const EdgeInsets.fromLTRB(40, 40, 40, 40) : const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: _selectionarchivo ? CircularProgressIndicator() : ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStatePropertyAll(0),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: _selectionarchivo ? null : () async {

                                setState(() {
                                  _selectionarchivo = true;
                                });

                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  setState(() {
                                    _selectedFile =
                                        File(result.files.single.path!);
                                    _fileselected = true;
                                  });
                                }

                                setState(() {
                                  _selectionarchivo = false;
                                });
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        height: 140,
                                        width: 140,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Icon(Icons.upload,
                                            size: 110,
                                            color: Colors.deepPurpleAccent)),
                                    SizedBox(height: 21),
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: Constantes.textIntrosubira,
                                              style: TextStyle(
                                                color: Constantes.kcBlackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30.0,
                                              )),
                                          TextSpan(
                                              text: Constantes
                                                  .textIntroDescsubira,
                                              style: TextStyle(
                                                  color: Constantes
                                                      .kcDarkBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0)),
                                        ])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
