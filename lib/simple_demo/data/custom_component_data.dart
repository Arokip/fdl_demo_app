import 'package:flutter/material.dart';

class MyComponentData {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  bool isHighlightVisible = false;

  MyComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.text = '',
  });

  MyComponentData.copy(MyComponentData customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}
