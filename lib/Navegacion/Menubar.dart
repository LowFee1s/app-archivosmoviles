import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../constantes.dart';

class Menubar extends StatelessWidget {
  final int index;
  final List<Color> colors;

  Menubar({required this.index, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: colors[0],
      color: colors[1],
      animationDuration: Duration(milliseconds: 300),
      index: index,
      items: <Widget>[
        Icon(Icons.insert_drive_file_sharp, size: 30, color: colors[2]),
        Icon(Icons.home, size: 30, color: colors[2]),
        Icon(Icons.settings, size: 30, color: colors[2]),
      ],
      onTap: (index) {
        //Handle button tap
        if (index == 0) {
          Navigator.pushReplacementNamed(context, Constantes.ArchivosNavegacion);
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, Constantes.HomeNavegacion);
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, Constantes.PerfilNavegacion);
        }
      },
    );
  }
}