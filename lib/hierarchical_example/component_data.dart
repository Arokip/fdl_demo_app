import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyComponentData {
  bool isHighlightVisible;
  Color color = Color.fromARGB(
    255,
    math.Random().nextInt(256),
    math.Random().nextInt(256),
    math.Random().nextInt(256),
  );

  MyComponentData({this.isHighlightVisible = false});

  void switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  void showHighlight() {
    isHighlightVisible = true;
  }

  void hideHighlight() {
    isHighlightVisible = false;
  }
}
