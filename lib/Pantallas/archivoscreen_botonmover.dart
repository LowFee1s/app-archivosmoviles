import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:appmovilesproyecto17/Apis/cloud_servicios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Navegacion/MarkerProvider.dart';

class MoverButton extends StatefulWidget {

  var nombrealmacenamiento;
  var idfile;
  var file;

  MoverButton({required this.nombrealmacenamiento, required this.idfile, required this.file});

  @override
  _MoverButton createState() => _MoverButton();
}

class _MoverButton extends State<MoverButton> {
  bool _fileselected = false;
  bool uploadtoGoogleDrive = false;
  bool uploadtoOneDrive = false;
  bool uploadToDropbox = false;
  bool _selectionarchivo = false;
  CloudServicios servicios = new CloudServicios();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    var isConnectedGoogleDrive = Provider.of<MarkerProvider>(context).isConnectedGoogleDrive;
    var usertokenGoogleDrive = Provider.of<MarkerProvider>(context).usertokenGoogleDrive;
    var usertokenOneDrive = Provider.of<MarkerProvider>(context).usertokenOneDrive;
    var isConnectedGoogleDriveFirebase = user!.providerData[0].providerId == "google.com";
    var isConnectedMicrosoftFirebase = user!.providerData[0].providerId == "microsoft.com";
    var isConnectedMicrosoft = Provider.of<MarkerProvider>(context).isConnectedMicrosoft;

    double screenwidth = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AlertDialog(
      scrollable: true,
      title: Text('Mover archivo'),
      content: Column(
        children: [
          Text(textAlign: TextAlign.center, "Selecciona el/los servicios a donde mover el archivo: ", style: TextStyle(fontWeight: FontWeight.w800, fontSize: screenwidth * 0.035, color: Colors.black)),
          Text(textAlign: TextAlign.center, "${widget.file}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: screenwidth * 0.034, color: Colors.deepPurpleAccent)),
          const SizedBox(height: 11),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 21, 0, 21),
            child: Column(
              children: [
                widget.nombrealmacenamiento != "AllCloud" ?
                CheckboxListTile(
                  title: Row(
                    children: [
                      Text('All Cloud'),
                      SizedBox(width: 17),
                      Icon(FontAwesomeIcons.cloud),
                    ],
                  ),
                  value: uploadToDropbox,
                  onChanged: (bool? value) { setState((){
                    uploadToDropbox = value!;
                  });},
                ) : Container(),
                widget.nombrealmacenamiento != "Google Drive" ?
                CheckboxListTile(
                    title: Row(
                      children: [
                        Text('Google Drive'),
                        SizedBox(width: 17),
                        Icon(FontAwesomeIcons.googleDrive),
                      ],
                    ),
                    value: uploadtoGoogleDrive,
                    onChanged: isConnectedGoogleDriveFirebase ||  Provider.of<MarkerProvider>(context).isConnectedGoogleDrive ? (bool? value) {
                      setState(() {
                        uploadtoGoogleDrive = value!;
                      });
                    } : null
                ) : Container(),
                widget.nombrealmacenamiento != "OneDrive" ?
                CheckboxListTile(
                    title: Row(
                      children: [
                        Text('One Drive'),
                        SizedBox(width: 17),
                        Icon(FontAwesomeIcons.microsoft),
                      ],
                    ),
                    value: uploadtoOneDrive,
                    onChanged: isConnectedMicrosoftFirebase ||  Provider.of<MarkerProvider>(context).isConnectedMicrosoft ? (bool? value) {
                      setState(() {
                        uploadtoOneDrive = value!;
                      });
                    }: null
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
            onPressed: uploadtoGoogleDrive || uploadtoOneDrive || uploadToDropbox ? () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return FutureBuilder(
                    future: servicios.moveFile(widget.nombrealmacenamiento, user, usertokenGoogleDrive!, usertokenOneDrive!, uploadtoGoogleDrive, uploadtoOneDrive, uploadToDropbox, widget.idfile, widget.file),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(width: 21),
                                Text("Moviendo el archivo....", style: TextStyle(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.error != null) {
                          // Manejar error aquí
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Si la carga fue exitosa, cierra el diálogo
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          return Container();
                        }
                      }
                    },
                  );
                },
              );
            } : null,
            child: Text('Mover Archivo'))
      ],
    );
  }
}
