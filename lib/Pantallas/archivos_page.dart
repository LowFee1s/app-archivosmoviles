import 'dart:async';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:appmovilesproyecto17/Navegacion/MarkerProvider.dart';
import 'package:appmovilesproyecto17/Pantallas/archivoscreen_botonagregar.dart';
import 'package:appmovilesproyecto17/Pantallas/archivoscreen_botonmover.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Apis/cloud_servicios.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FilesPage extends StatefulWidget {
  FilesPage({Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  // Supongamos que estos son los archivos obtenidos de los servicios
  List<Map<String, Object?>> driveFiles = [];
  List<Map<String, Object?>> allcloudFiles = [];
  List<Map<String, Object?>> oneDriveFiles = [];
  List<Map<String, Object?>> allFiles = [];
  String? _filterService;
  String? _filterfecha11;
  String? _filterName;
  String? _chosenValue;
  final TextEditingController controllerinput11 = TextEditingController();
  final TextEditingController dateController11 = TextEditingController();
  User? userprovider = FirebaseAuth.instance.currentUser;
  String? _inputValue11;
  var isConnectedGoogleDrive;
  var isConnectedOneDrive;
  var isConnectedOneDriveFirebase;
  var usertokenGoogleDrive;
  var onedriveFiles1;
  var isloading = false;
  var allcloudFiles1;
  var usertokenOneDrive;
  var isConnectedGoogleDriveFirebase;
  var contextapp;
  String? _inputValue;
  Timer? _timer;
  int? _selectedRow;
  CloudServicios servicios = new CloudServicios();

  void _updateArchivos() async {
    var driveFiles1;
    if (isConnectedGoogleDriveFirebase) {
      driveFiles1 = await servicios.getGoogleDriveFiles("");
    }

    if (isConnectedGoogleDrive) {
      driveFiles1 = await servicios.getGoogleDriveFiles(usertokenGoogleDrive);
      if (driveFiles1 == []) {
        Provider.of<MarkerProvider>(contextapp, listen: false).setusertokenGoogleDrive = "";
        Provider.of<MarkerProvider>(contextapp, listen: false).setisConnectedGoogleDrive = false;
      }
    }
    if (FirebaseAuth.instance.currentUser != null) {
      allcloudFiles1 = await servicios.getAllcloudFiles(FirebaseAuth.instance.currentUser!.uid);
    }
    if (isConnectedOneDriveFirebase) {
      onedriveFiles1 = await servicios.getFilesOnedrive(usertokenOneDrive);
    }
    if (isConnectedOneDrive) {
      onedriveFiles1 = await servicios.getFilesOnedrive(usertokenOneDrive);
      if (onedriveFiles1 == []) {
        Provider.of<MarkerProvider>(contextapp, listen: false).setusertokenOneDrive = "";
        Provider.of<MarkerProvider>(contextapp, listen: false).setisConnectedMicrosoft = false;
      }
    }
    setState(() {
      if (isConnectedGoogleDriveFirebase || isConnectedGoogleDrive) {
        driveFiles = driveFiles1;
      }
      if (FirebaseAuth.instance.currentUser != null) {
        allcloudFiles = allcloudFiles1;
      }
      if (isConnectedOneDriveFirebase || isConnectedOneDrive) {
        oneDriveFiles = onedriveFiles1;
      }
      if ((isConnectedGoogleDriveFirebase || isConnectedGoogleDrive) && (FirebaseAuth.instance.currentUser != null) && (isConnectedOneDriveFirebase || isConnectedOneDrive)) {
        allFiles = []..addAll(driveFiles1)..addAll(onedriveFiles1)..addAll(allcloudFiles1);
      } else if ((isConnectedOneDriveFirebase || isConnectedOneDrive) && (FirebaseAuth.instance.currentUser != null)) {
        allFiles = []..addAll(onedriveFiles1)..addAll(allcloudFiles1);
      } else if ((isConnectedGoogleDriveFirebase || isConnectedGoogleDrive) && (FirebaseAuth.instance.currentUser != null)) {
        allFiles = []..addAll(driveFiles1)..addAll(allcloudFiles1);
      } else if (FirebaseAuth.instance.currentUser != null) {
        allFiles = []..addAll(allcloudFiles1);
      }
      allFiles.sort((a, b)=>DateTime.parse(b['fecha'].toString()).compareTo(DateTime.parse(a['fecha'].toString())));
     // oneDriveFiles = onedriveFiles1;
      _filterData(_filterService, _filterfecha11, _filterName);
    });
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _updateArchivos();
    });
  }

  @override
  void initState() {
    super.initState();
    isConnectedGoogleDriveFirebase = userprovider!.providerData[0].providerId == "google.com";
    isConnectedOneDriveFirebase = userprovider!.providerData[0].providerId == "microsoft.com";
    _updateArchivos();
    _startPolling();
  }

  void _showFilterSheet() {

    if (_chosenValue == "" && _inputValue11 == null && _inputValue == null) {
      controllerinput11.text = "";
      Provider.of<MarkerProvider>(context, listen: false).settipoDriveFile = "";
      dateController11.text = "";
    }

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height/1.5 + 100,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 21, 17, 21),
              child: Container(
                height: 10,
                width: 210,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(),
                  ),
              ),
            ),
            Text("Filtrar por servicio, fecha o nombre", style: TextStyle(fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.05)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Servicio: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.04)),
                Container(
                  child: DropdownButton<String>(
                    value: context.watch<MarkerProvider>().usertipoDriveFile,
                    items: <String>['Todos', 'Google Drive', 'AllCloud', 'OneDrive']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text("Selecciona un servicio"),
                    onChanged: (String? value) {
                      setState(() {
                        Provider.of<MarkerProvider>(context, listen: false).settipoDriveFile = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: controllerinput11,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(110),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _inputValue = value;
                        controllerinput11.text = value;
                      });
                    },
                    decoration: InputDecoration(border: InputBorder.none, labelText: "Ingresa el nombre del archivo", hoverColor: Colors.white, labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                  child: TextField(
                    controller: dateController11,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateController11.text = DateFormat('yyyy:MM:dd').format(date);
                        setState(() {
                          _inputValue11 = dateController11.text;
                        });
                      }
                    },
                    style: TextStyle(color: Colors.white),

                    decoration: InputDecoration(border: InputBorder.none, labelText: "Selecciona la fecha del archivo", hoverColor: Colors.white, labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ElevatedButton(
              child: Text('Filtrar'),
              onPressed: (context.watch<MarkerProvider>().usertipoDriveFile != "Todos" && context.watch<MarkerProvider>().usertipoDriveFile != "") || (_inputValue11 != null && _inputValue11 != "") || (_inputValue != null && _inputValue != "") ? () {
                Navigator.pop(context);
                print("Filtrando: $_chosenValue, ${_inputValue11 != "" ? _inputValue11 : "null"}, ${_inputValue != "" ? _inputValue : "null"}");
                _filterData(_chosenValue == "Todos" ? null : _chosenValue, _inputValue11, _inputValue);
              } : null ,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      );
    },
  );
}

  void showTopSnackBar1 (BuildContext context, String message, Color color) {
    Flushbar(
      titleText: Text("Archivo subido", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
      backgroundColor: Colors.green,
      icon: Icon(Icons.check, color: Colors.white),
      messageColor: Colors.white,
      maxWidth: MediaQuery.of(context).size.width * 1,
      flushbarPosition: FlushbarPosition.TOP,
      shouldIconPulse: false,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      borderRadius: BorderRadius.circular(21),
      padding: EdgeInsets.all(21),
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      messageText: Text("El archivo se ha subido correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.032, color: Colors.white)),
      duration: Duration(seconds: 5),
    )..show(context);
  }

  void showTopSnackBar17 (BuildContext context, String message, Color color) {
      Flushbar(
        backgroundColor: color,
        icon: Icon(Icons.download_done_rounded, color: Colors.white),
        messageColor: Colors.white,
        titleText: Text("Archivo descargado", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        shouldIconPulse: false,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        borderRadius: BorderRadius.circular(21),
        padding: EdgeInsets.all(21),
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        messageText: Text(message, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
        duration: Duration(seconds: 5),
      )..show(context);
    }

  void _filterData(String? service, String? fechaarchivo11, String? name) {

  _filterService = service;
  _filterfecha11 = fechaarchivo11;
  _filterName = name;

  if (service != null && service.isNotEmpty) {
    // Filtrar por servicio
    allFiles = allFiles.where((file) => file['servicio'] == service).toList();
  }
  if (fechaarchivo11 != null && fechaarchivo11.isNotEmpty) {
    // Filtrar por fecha
    allFiles = allFiles.where((file) => DateFormat("yyyy:MM:dd").format(DateTime.parse(file['fecha'].toString())) == fechaarchivo11.toString()).toList();
  }
  if (name != null && name.isNotEmpty) {
    // Filtrar por nombre
    allFiles = allFiles.where((file) => (file['nombre'] as String).toLowerCase().contains(name.toLowerCase())).toList();
  }
  setState(() {});
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    isConnectedGoogleDrive = Provider.of<MarkerProvider>(context).isConnectedGoogleDrive;
    contextapp = context;
    isConnectedOneDrive = Provider.of<MarkerProvider>(context).isConnectedMicrosoft;
    _chosenValue = context.watch<MarkerProvider>().usertipoDriveFile;
    usertokenGoogleDrive = Provider.of<MarkerProvider>(context).usertokenGoogleDrive;
    usertokenOneDrive = Provider.of<MarkerProvider>(context).usertokenOneDrive;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return LayoutBuilder(
      builder: (context, constrains) {

        double tablaancho = constrains.maxWidth;
        double fontSize = MediaQuery.of(context).size.width * 0.04;

        return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Archivos General'),
          actions: [
            IconButton(
                onPressed: () {
                  _showFilterSheet();
                },
                icon: Icon(FontAwesomeIcons.filter)
            ),
          ],
        ),
        body: Container(
          width: tablaancho,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: allFiles.isEmpty ?
                    Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/quitararchivo.png", height: 150),
                        Container(child: Padding(
                          padding: const EdgeInsets.all(21.0),
                          child: Text(textAlign: TextAlign.center, "Ooops. Parece que no hay archivos. Sube alguno para verlos aqui.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21)),
                        ),),
                      ],
                    ),)
                    : SingleChildScrollView(
                    child: DataTable(
                        showBottomBorder: true,
                        showCheckboxColumn: false,
                        columnSpacing: tablaancho * 0.015,
                        dataRowHeight: 80,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Servicio'),
                          ),
                          DataColumn(
                            label: Text('Archivo'),
                          ),
                          DataColumn(
                            label: Text('Fecha'),
                          ),
                        ],
                        rows: allFiles
                            .asMap()
                            .entries
                            .map((file) => _crearFila(
                                file.key, file.value['servicio'].toString(),
                                file.value['servicio'] == "Google Drive" ? FaIcon(FontAwesomeIcons.googleDrive) : file.value['servicio'] == "AllCloud" ? FaIcon(FontAwesomeIcons.cloud) : FaIcon(FontAwesomeIcons.microsoft),
                                file.value['nombre'].toString(), file.value['id'].toString(), file.value['screenarchivo'].toString(), file.value['size'].toString(),
                                file.value['extension'].toString(),
                                DateFormat('yyyy:MM:dd - kk:mm').format(
                                    DateTime.parse(file.value['fecha'].toString()))))
                            .toList(),
                        // ..addAll(dropboxFiles.map((file) => _crearFila(FaIcon(FontAwesomeIcons.dropbox), file)))
                        // ..addAll(oneDriveFiles.map((file) => _crearFila(FaIcon(FontAwesomeIcons.cloud), file))),
                        ),
                  ),
                  ),
                (_filterService != null || _filterfecha11 != null ||_filterName != null) && (_filterService != "" || _filterfecha11 != "" || _filterName != "")
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.31,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.black, width: 1), left: BorderSide(color: Colors.black, width: 1), right: BorderSide(color: Colors.black, width: 1)),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.017),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(5)),
                                onPressed: () {
                                  _filterName = null;
                                  _inputValue11 = null;
                                  _inputValue = null;
                                  _chosenValue = null;
                                  controllerinput11.text = "";
                                  dateController11.text = "";
                                  _filterfecha11 = null;
                                  _filterService = null;
                                  Provider.of<MarkerProvider>(context, listen: false).settipoDriveFile = "Todos";
                                  _updateArchivos();
                                },
                                child: Icon(Icons.arrow_back_rounded, color: Colors.deepPurpleAccent, size: 25),
                              ),
                              Text(textAlign: TextAlign.center, "Total de archivos filtrados:\n ${allFiles.length}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: fontSize)),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.017),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(textAlign: TextAlign.center, "Filtrando por:\n ${_filterService == null ? "" : "Tipo: $_filterService"}       ${_filterfecha11 == null ? "" : "Fecha: $_filterfecha11"}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize)),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.017),
                              Text(textAlign: TextAlign.center, "${_filterName == null || _filterName == "" ? "" : "Nombre: $_filterName"}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: fontSize)),
                            ],
                          ),
                        ],
                      )
                  )
                  : Container(),
                ],
              ),
              (_filterService != null || _filterfecha11 != null ||_filterName != null) && (_filterService != "" || _filterfecha11 != "" || _filterName != "")
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.fromLTRB(21, 0, 21, 50),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(21)),
                    onPressed: () {
                       var modalboton = showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: AgregarButton(),
                              ),
                            );
                          });
                      modalboton.then((value) {
                        if (value == true) {
                          showTopSnackBar1(
                              context, "Archivo subido correctamente",
                              Colors.green);
                        }
                      });
                    },
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
       // bottomNavigationBar: Menubar(index: 0, colors: [Colors.transparent, Colors.black, Colors.deepPurpleAccent]),
      );
      }
    );
  }

  String formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = [
      "B",
      "KB",
      "MB",
      "GB",
      "TB",
      "PB",
      "EB",
      "ZB",
      "YB"
    ];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Icon imagenselection(String file) {
    String extension = file;
    double size = 49.0;

    switch (extension) {
      case 'application/msword':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return Icon(FontAwesomeIcons.fileWord, size: size, color: Colors.blue); // Ícono para documentos de texto
      case 'application/vnd.ms-excel':
      case 'application/vnd.google-apps.spreadsheet':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return Icon(FontAwesomeIcons.fileExcel, size: size, color: Colors.green); // Ícono para hojas de cálculo
      case 'application/vnd.ms-powerpoint':
      case 'application/vnd.google-apps.presentation':
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return Icon(FontAwesomeIcons.filePowerpoint, size: size, color: Colors.orange); // Ícono para presentaciones
      case 'image/jpg':
      case 'image/jpeg':
      case 'image/png':
        return Icon(FontAwesomeIcons.fileImage, size: size, color: Colors.purple); // Ícono para imágenes
      case 'application/vnd.google-apps.video':
      case 'video/mp4':
        return Icon(FontAwesomeIcons.fileVideo, size: size, color: Colors.red); // Ícono para videos
      case 'application/vnd.google-apps.audio':
      case 'audio/mpeg':
      case 'audio/wav':
        return Icon(FontAwesomeIcons.fileAudio, size: size, color: Colors.yellow); // Ícono para audios
      case 'application/vnd.google-apps.form':
      case 'application/pdf':
        return Icon(FontAwesomeIcons.filePdf, size: size, color: Colors.red); // Ícono para PDFs
      case 'application/vnd.google-apps.document':
        return Icon(FontAwesomeIcons.file, size: size, color: Colors.white); // Ícono para PDFs
      case 'text/csv':
      case 'text/plain':
        return Icon(FontAwesomeIcons.fileAlt, size: size, color: Colors.grey); // Ícono para archivos de texto
      case 'application/zip':
      case 'application/x-rar-compressed':
        return Icon(FontAwesomeIcons.fileArchive, size: size, color: Colors.brown); // Ícono para archivos comprimidos
      default:
        return Icon(FontAwesomeIcons.file, size: size, color: Colors.black); // Ícono por defecto para otros tipos de archivo
    }
  }

  String archivoselection(String file) {
    String extension = file;

    switch (extension) {
      case 'application/vnd.google-apps.document':
        return ".pdf/doc";
      case 'application/pdf':
        return ".pdf";
      case 'application/msword':
        return ".doc";
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return ".docx";
      case 'application/vnd.ms-excel':
        return ".xls";
      case 'application/vnd.google-apps.spreadsheet':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return ".xlsx";
      case 'application/vnd.ms-powerpoint':
      case 'application/vnd.google-apps.presentation':
        return ".ppt";
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return ".pptx";
      case 'image/jpg':
        return ".jpg";
      case 'image/jpeg':
        return ".jpeg";
      case 'image/png':
        return ".png";
      case 'application/vnd.google-apps.video':
      case 'video/mp4':
        return ".mp4";
      case 'application/vnd.google-apps.audio':
      case 'audio/mpeg':
        return ".mp3";
      case 'audio/wav':
        return ".wav";
      case 'application/vnd.google-apps.form':
        return ".form";
      case 'application/pdf':
        return ".pdf";
      case 'text/csv':
        return ".csv";
      case 'text/plain':
        return ".txt";
      case 'application/zip':
        return ".zip";
      case 'application/x-rar-compressed':
        return ".rar";
      case 'application/octet-stream':
        return ".bin";
      case 'application/json':
        return ".json";
      case 'application/javascript':
        return ".js";
      case 'application/xml':
        return ".xml";
      case 'image/gif':
        return ".gif";
      case 'image/tiff':
        return ".tiff";
      case 'video/mpeg':
        return ".mpeg";
      case 'audio/x-wav':
        return ".wav";
      case 'audio/amr':
        return ".amr";
      case 'application/x-7z-compressed':
        return ".7z";
      case 'application/x-tar':
        return ".tar";
      case 'application/x-bzip':
        return ".bz";
      case 'application/x-bzip2':
        return ".bz2";
      case 'application/x-shockwave-flash':
        return ".swf";
      case 'application/rtf':
        return ".rtf";
      case 'application/x-font-ttf':
        return ".ttf";
      case 'application/font-woff':
        return ".woff";
      case 'application/vnd.ms-fontobject':
        return ".eot";
      case 'image/svg+xml':
        return ".svg";
      case 'image/webp':
        return ".webp";
      case 'audio/ogg':
        return ".ogg";
      case 'video/ogg':
        return ".ogv";
      case 'application/ogg':
        return ".ogx";
      case 'video/webm':
        return ".webm";
      case 'audio/webm':
        return ".weba";
      case 'application/x-perl':
        return ".pl";
      case 'application/x-python-code':
        return ".pyc";
      case 'text/x-python':
        return ".py";
      case 'application/java-archive':
        return ".jar";
      case 'text/x-java-source':
        return ".java";
      case 'application/x-ruby':
        return ".rb";
      case 'application/x-php':
        return ".php";
      case 'text/html':
        return ".html";
      case 'text/css':
        return ".css";
      case 'application/xhtml+xml':
        return ".xhtml";
      case 'application/xml':
        return ".xml";
      case 'application/sql':
        return ".sql";
      case 'application/x-shellscript':
        return ".sh";
      case 'application/x-csh':
        return ".csh";
      case 'text/x-c':
        return ".c";
      case 'text/x-c++':
        return ".cpp";
      case 'text/x-fortran':
        return ".f";
      case 'text/x-go':
        return ".go";
      case 'text/x-script.lisp':
        return ".lisp";
      case 'text/x-script.scheme':
        return ".scm";
      case 'text/x-pascal':
        return ".pas";
      case 'text/x-script.perl':
        return ".pl";
      case 'text/x-script.python':
        return ".py";
      case 'text/x-script.ruby':
        return ".rb";
      case 'text/x-script.tcl':
        return ".tcl";
      case 'text/x-script.zsh':
        return ".zsh";
      case 'text/x-script':
        return ".script";
      case 'text/x-asm':
        return ".asm";
      case 'text/x-h':
        return ".h";
      case 'text/x-java':
        return ".java";
      case 'text/x-lua':
        return ".lua";
      case 'text/x-markdown':
        return ".md";
      case 'text/x-php':
        return ".php";
      case 'text/x-rust':
        return ".rs";
      case 'text/x-swift':
        return ".swift";
      case 'text/x-typescript':
        return ".ts";
      case 'text/x-vb':
        return ".vb";
      case 'text/x-vhdl':
        return ".vhdl";
      case 'text/x-verilog':
        return ".v";
      case 'text/x-csharp':
        return ".cs";
      case 'text/x-fsharp':
        return ".fs";
      case 'text/x-objcsrc':
        return ".m";
      case 'text/x-scala':
        return ".scala";
      case 'text/x-kotlin':
        return ".kt";
      default:
        return "";
    }
  }

  DataRow _crearFila(int index, String nombrealmacenamiento, FaIcon icon, String file, String id, String thumblink, String size, String extension, String fecha) {
    double screenwidth = MediaQuery.of(context).size.width;
    String limitarTexto(String texto, int rango) {
      return (texto.length <= rango)
          ? texto
          : texto.substring(0, rango) + "....";
    }

    void showTopSnackBar(BuildContext context, String message, Color color) {
      Flushbar(
        titleText: Text("Archivo eliminado", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        messageText: Text(message, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
        duration: Duration(seconds: 5),
        backgroundColor: color,
        borderRadius: BorderRadius.circular(21),
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        shouldIconPulse: false,
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        padding: EdgeInsets.all(21),
        icon: Icon(FontAwesomeIcons.trash, color: Colors.white),
      )..show(context);
    }

    void showTopSnackBar117(BuildContext context, String message, Color color) {
      Flushbar(
        titleText: Text("Archivo movido", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        messageText: Text(message, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
        duration: Duration(seconds: 5),
        backgroundColor: color,
        borderRadius: BorderRadius.circular(21),
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        shouldIconPulse: false,
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        padding: EdgeInsets.all(21),
        icon: Icon(FontAwesomeIcons.fileExport, color: Colors.white),
      )..show(context);
    }

    void showTopSnackBar114(BuildContext context, String message, Color color) {
      Flushbar(
        titleText: Text("Archivo compartido", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        messageText: Text(message, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
        duration: Duration(seconds: 5),
        backgroundColor: color,
        borderRadius: BorderRadius.circular(21),
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        shouldIconPulse: false,
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        padding: EdgeInsets.all(21),
        icon: Icon(FontAwesomeIcons.share, color: Colors.white),
      )..show(context);
    }


    bool uploadtoGoogleDrive = Provider.of<MarkerProvider>(context).moveGoogleDriveFile;
    bool uploadtoOneDrive = Provider.of<MarkerProvider>(context).moveOneDriveFile;
    bool uploadToDropbox = Provider.of<MarkerProvider>(context).moveAllCloudFile;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected))
          return Theme.of(context).colorScheme.primary.withOpacity(0.08);
        if (index % 2 == 0) return Colors.grey.withOpacity(0.2);
        return null;
      }),
      selected: _selectedRow == index,
      onSelectChanged: (bool? selected) {
        setState(() {
          if (selected != null && selected) {
            var modal = showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(40))),
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
                                    SizedBox(height: 15),
                                    Container(
                                      width: 200,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50)),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(Colors.black),
                                        ),
                                        child: Container(),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 31),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Column(
                                        children: [
                                          Text("Nombre del Archivo: ",
                                              style:
                                                  TextStyle(fontWeight: FontWeight.w800)),
                                          Text(textAlign: TextAlign.center, file, style: TextStyle(fontWeight: FontWeight.w800)),
                                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                          Padding(
                                            padding: const EdgeInsets.all(17.0),
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
                                                      imagenselection(extension.toLowerCase()),
                                                      Text(archivoselection(extension.toLowerCase()), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(textAlign: TextAlign.center, "Tamaño del archivo: \n ${formatBytes(int.parse(size))}", style: TextStyle(fontWeight: FontWeight.w500)),
                                                    const SizedBox(height: 17),
                                                    Text(textAlign: TextAlign.center, "Fecha del archivo: \n ${fecha}", style: TextStyle(fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.deepPurpleAccent,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  Provider.of<MarkerProvider>(context, listen: false).setisloadingshare = true;
                                                });
                                                await servicios.shareFile(context, nombrealmacenamiento, id, file, FirebaseAuth.instance.currentUser!, usertokenOneDrive, usertokenGoogleDrive).then((value) {
                                                });
                                                setState(() {
                                                  Provider.of<MarkerProvider>(context, listen: false).setisloadingshare = false;
                                                });
                                              },
                                              child: Provider.of<MarkerProvider>(context).isloadingshare ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.share, color: Colors.white, size: 21)
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Previsualizacion del archivo: ${thumblink == "null" || nombrealmacenamiento == "AllCloud" ? "No" : "Si"}",
                                                        style:
                                                        TextStyle(fontWeight: FontWeight.w800)),
                                                    thumblink == "null" || nombrealmacenamiento == "AllCloud" ? Container()
                                                    : Container(
                                                          padding: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey, width: 2),
                                                              borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: IconButton(icon: Image.network(thumblink, height: screenwidth * 0.35, filterQuality: FilterQuality.high, fit: BoxFit.cover),
                                                            style: ButtonStyle(
                                                              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      contentPadding: EdgeInsets.all(0),
                                                                      content: Image.network(
                                                                          thumblink,
                                                                          filterQuality: FilterQuality.high,
                                                                          fit: BoxFit.cover
                                                                      ),
                                                                    );
                                                                  }
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
                                                  child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Align(
                                                                alignment: Alignment.bottomRight,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.orange,
                                                                          shape: CircleBorder(),
                                                                          padding: EdgeInsets.all(21),
                                                                        ),
                                                                        onPressed: () {
                                                                         var movefileuser11 = showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return MoverButton(nombrealmacenamiento: nombrealmacenamiento, idfile: id, file: file);
                                                                              }
                                                                          );
                                                                         movefileuser11.then((value) {
                                                                           if (value) {
                                                                             showTopSnackBar117(context, "Se movio el archivo correctamente: ${file}", Colors.orange);
                                                                           }
                                                                         });
                                                                        },
                                                                        child: Icon(FontAwesomeIcons.fileExport, color: Colors.white, size: 21)
                                                                    ),
                                                                    const SizedBox(height: 20),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.lightBlue,
                                                                          shape: CircleBorder(),
                                                                          padding: EdgeInsets.all(21),
                                                                        ),
                                                                        onPressed: () {
                                                                          // descargar
                                                                          nombrealmacenamiento == "Google Drive" ?
                                                                          servicios.downloadFiletoGoogleDrive(usertokenGoogleDrive, id)
                                                                          : nombrealmacenamiento == "AllCloud" ?
                                                                          servicios.downloadFileFromAllCloud(FirebaseAuth.instance.currentUser!.uid, file) :  servicios.downloadFileFromOneDrive(usertokenOneDrive, id);
                                                                          Navigator.of(context).pop();
                                                                          showTopSnackBar17(context, "Se descargo el archivo correctamente: ${file}", Colors.blue);
                                                                        },
                                                                        child: Icon(FontAwesomeIcons.download, color: Colors.white, size: 21)
                                                                    ),
                                                                    const SizedBox(height: 20),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.red,
                                                                          shape: CircleBorder(),
                                                                          padding: EdgeInsets.all(21),
                                                                        ),
                                                                        onPressed: () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text('Confirmacion'),
                                                                                  content: Text('¿Estas seguro de que quieres borrar este archivo?: ${file}'),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          // Borrar
                                                                                          nombrealmacenamiento == "Google Drive" ?
                                                                                          servicios.deleteGoogleDriveFile(id, usertokenGoogleDrive) : nombrealmacenamiento == "AllCloud"
                                                                                          ? servicios.deletetoAllCloudFile(FirebaseAuth.instance.currentUser!.uid, file) : servicios.deletetoOneDriveFile(id, usertokenOneDrive);
                                                                                          Navigator.of(context).pop();
                                                                                          Navigator.of(context).pop();
                                                                                          showTopSnackBar(context, "Se borro el archivo correctamente: ${file}", Colors.red);
                                                                                        },
                                                                                        child: Text('Confirmar'))
                                                                                  ],
                                                                                );
                                                                              }
                                                                          );
                                                                        },
                                                                        child: Icon(FontAwesomeIcons.trash, color: Colors.white, size: 21)
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        ],
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                  Center(child: Text("Subido en: ${nombrealmacenamiento}", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey))),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                  Center(child: Icon(color: Colors.grey, nombrealmacenamiento == "Google Drive" ? FontAwesomeIcons.googleDrive : nombrealmacenamiento == "AllCloud" ? FontAwesomeIcons.cloud : FontAwesomeIcons.microsoft)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                  );
                }
            );
            modal.then((value) => Provider.of<MarkerProvider>(context, listen: false).setisloadingshare = false);
          }
        });
      },
      cells: <DataCell>[
        DataCell(Container(width: 10, child: Icon(icon.icon))),
        DataCell(Container(
            width: 200,
            child: Text(limitarTexto(file, 25), overflow: TextOverflow.fade))),
        DataCell(Text(fecha)),
      ],
    );
  }
}

class MiModalBottomSheet extends StatefulWidget {
  @override
  _MiModalBottomSheetState createState() => _MiModalBottomSheetState();
}

class _MiModalBottomSheetState extends State<MiModalBottomSheet> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 21, 17, 21),
            child: Container(
              height: 10,
              width: 210,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(),
              ),
            ),
          ),
          Text("Filtrar por servicio, fecha o nombre", style: TextStyle(fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.05)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Servicio: ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width * 0.04)),
              Container(
                child: DropdownButton<String>(
                  value: _chosenValue,
                  items: <String>['Google Drive', 'AllCloud', 'OneDrive']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text("Selecciona un servicio"),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
