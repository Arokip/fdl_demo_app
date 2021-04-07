import 'package:flutter/material.dart';

class MyComponentData {
  Color color;
  Color borderColor;

  String text;
  bool isHighlightVisible = false;

  MyComponentData({
    this.color,
    this.borderColor = Colors.black,
    this.text,
  });

  MyComponentData.copy(MyComponentData customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
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
