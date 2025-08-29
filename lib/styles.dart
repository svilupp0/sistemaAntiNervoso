import 'package:flutter/material.dart';

// 🌈 Colori arcobaleno
class RainbowColors {
  static const red = Colors.red;
  static const orange = Colors.orange;
  static const yellow = Colors.yellow;
  static const green = Colors.green;
  static const blue = Colors.blue;
  static const indigo = Colors.indigo;
  static const purple = Colors.purple;

  static const all = [red, orange, yellow, green, blue, indigo, purple];
}

// Gradient per sfondo
final LinearGradient rainbowGradient = LinearGradient(
  colors: RainbowColors.all,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Stile testo principale
final TextStyle mainTitleStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [Shadow(blurRadius: 3, color: Colors.black, offset: Offset(1, 1))],
);

// Stile testo info
final TextStyle infoTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
);

// Stile bottoni
ButtonStyle rainbowButtonStyle(Color color) => ElevatedButton.styleFrom(
  backgroundColor: color,
  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);
