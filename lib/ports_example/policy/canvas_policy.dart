import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    canvasWriter.model.hideAllLinkJoints();

    if (selectedPortId == null) {
      addComponentDataWithPorts(
          canvasReader.state.fromCanvasCoordinates(details.localPosition));
    }
    deselectAllPorts();
  }
}
