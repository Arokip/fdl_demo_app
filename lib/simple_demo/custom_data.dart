import 'package:flutter/material.dart';

class CustomData {
  Color color;
  Color borderColor;

  String text;
  bool isHighlightVisible = false;

  CustomData({
    this.color,
    this.borderColor = Colors.black,
    this.text,
  });

  CustomData.copy(CustomData customData)
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
