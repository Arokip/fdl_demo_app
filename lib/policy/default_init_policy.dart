import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin DefaultInitPolicy implements InitPolicy {
  initializeDiagram() {
    canvasWriter.state.setCanvasColor(Colors.grey);
  }
}
