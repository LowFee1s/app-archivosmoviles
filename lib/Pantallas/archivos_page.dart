import 'dart:async';
import 'dart:math';
import 'package:appmovilesproyecto17/Pantallas/archivoscreen_botonagregar.dart';
import 'package:appmovilesproyecto17/constantes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Apis/cloud_servicios.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Navegacion/Menubar.dart';

class FilesPage extends StatefulWidget {
  FilesPage({Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  // Supongamos que estos son los archivos obtenidos de los servicios
  List<Map<String, Object?>> driveFiles = [];
  List<String> dropboxFiles = ['Archivo 4', 'Archivo 5'];
  List<String> oneDriveFiles = [];
  Timer? _timer;
  int? _selectedRow;
  CloudServicios servicios = new CloudServicios();

  void _updateArchivos() async {
    var driveFiles1 = await servicios.getGoogleDriveFiles();
    setState(() {
      driveFiles = driveFiles1;
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
    _updateArchivos();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Archivos General'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.filter)
          ),
        ],
      ),
      body: Stack(
        children: [
          driveFiles.isEmpty ?
          Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/img/quitararchivo.png", height: 150),
              Container(child: Padding(
                padding: const EdgeInsets.all(21.0),
                child: Text(textAlign: TextAlign.center, "Ooops. Parece que no tienes archivos. Sube alguno para verlos aqui.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21)),
              ),),
            ],
          ),)
          : SingleChildScrollView(
            child: DataTable(
                showBottomBorder: true,
                showCheckboxColumn: false,
                columnSpacing: 17,
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
                rows: driveFiles
                    .asMap()
                    .entries
                    .map((file) => _crearFila(
                        file.key,
                        FaIcon(FontAwesomeIcons.googleDrive),
                        file.value['nombre'].toString(), file.value['id'].toString(), file.value['size'].toString(),
                        file.value['extension'].toString(),
                        DateFormat('yyyy:MM:dd - kk:mm').format(
                            DateTime.parse(file.value['fecha'].toString()))))
                    .toList()
                // ..addAll(dropboxFiles.map((file) => _crearFila(FaIcon(FontAwesomeIcons.dropbox), file)))
                // ..addAll(oneDriveFiles.map((file) => _crearFila(FaIcon(FontAwesomeIcons.cloud), file))),
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(21, 0, 21, 100),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20)),
                onPressed: () {
                  showModalBottomSheet(
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
                },
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Menubar(index: 0, colors: [Colors.transparent, Colors.black, Colors.white]),
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

  DataRow _crearFila(int index, FaIcon icon, String file, String id, String size, String extension, String fecha) {
    String limitarTexto(String texto, int rango) {
      return (texto.length <= rango)
          ? texto
          : texto.substring(0, rango) + "....";
    }

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected))
          return Theme.of(context).colorScheme.primary.withOpacity(0.08);
        if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
        return null;
      }),
      selected: _selectedRow == index,
      onSelectChanged: (bool? selected) {
        setState(() {
          if (selected != null && selected) {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                                  SizedBox(height: 41),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(17, 0, 17, 100),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlue,
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(21),
                                      ),
                                      onPressed: () {
                                        // descargar
                                        servicios.downloadFiletoGoogleDrive(id);
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text("Se descargo el archivo correctamente"),
                                              );
                                            }
                                        );
                                      },
                                      child: Icon(FontAwesomeIcons.download, color: Colors.white, size: 21)
                                  ),
                                  const SizedBox(height: 40),
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
                                                        servicios.deleteGoogleDriveFile(id);
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
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
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
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
