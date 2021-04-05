import 'package:flutter/material.dart';

class CustomData {
  Color color;
  String text;
  bool isHighlightVisible = false;

  CustomData({
    this.color,
    this.text,
  });

  CustomData.copy(CustomData customData)
      : this(
          color: customData.color,
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
