import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo_old/policy/custom_policy.dart';
import 'package:diagram_editor_apps/port_demo_old/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  onCanvasTap() {
    selectedComponentId = null;

    canvasWriter.model.hideAllLinkJoints();
    // canvasWriter.model.hideAllTapLinkWidgets();
    selectedLinkId = null;
    hideAllHighlights();
  }

  @override
  onCanvasLongPressStart(LongPressStartDetails details) {
    String componentId = canvasWriter.model.addComponent(
      ComponentData(
        position:
            canvasReader.state.fromCanvasCoordinates(details.localPosition),
        size: Size(
          math.Random().nextInt(120) + 80.0,
          math.Random().nextInt(80) + 80.0,
        ),
        data: RectCustomData(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          text: 'custom text',
        ),
        type: 'rect',
      ),
    );
    canvasWriter.model.moveComponentToTheFront(componentId);
  }
}