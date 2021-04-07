import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  onCanvasTap() {
    selectedComponentId = null;

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
        data: MyComponentData(
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
