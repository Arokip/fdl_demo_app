import 'package:flutter/material.dart';

class MyComponentData {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  Alignment textAlignment;
  double textSize;

  bool isHighlightVisible = false;

  MyComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 20,
  });

  MyComponentData.copy(MyComponentData other)
      : this(
          color: other.color,
          borderColor: other.borderColor,
          borderWidth: other.borderWidth,
          text: other.text,
          textAlignment: other.textAlignment,
          textSize: other.textSize,
        );

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
