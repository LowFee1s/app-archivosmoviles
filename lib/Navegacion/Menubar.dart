import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../constantes.dart';

class Menubar extends StatelessWidget {
  final int index;
  final List<Color> colors;
  final Function(int) onTap; // Add this line

  Menubar({required this.index, required this.colors, required this.onTap}); // Modify this line

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
      onTap: onTap, // Modify this line
    );
  }
}