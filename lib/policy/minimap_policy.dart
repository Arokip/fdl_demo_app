import 'package:diagram_editor_apps/policy/component_design.dart';
import 'package:flutter/material.dart';
import 'package:diagram_editor/diagram_editor.dart';

class MiniMapPolicySet extends PolicySet
    with MiniMapInitPolicy, CanvasControlPolicy, MyComponentDesignPolicy {}

mixin MiniMapInitPolicy implements InitPolicy {
  @override
  initializeDiagram() {
    canvasWriter.state.setMinScale(0.025);
    canvasWriter.state.setMaxScale(0.25);
    canvasWriter.state.setScale(0.1);
    canvasWriter.state.setCanvasColor(Colors.grey[300]);
  }
}
