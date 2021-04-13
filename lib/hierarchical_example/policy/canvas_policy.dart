import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/component_data.dart';
import 'package:diagram_editor_apps/hierarchical_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  var sizes = [
    Size(80, 60),
    Size(200, 150),
  ];

  @override
  onCanvasTapUp(TapUpDetails details) {
    canvasWriter.model.hideAllLinkJoints();

    if (isReadyToAddParent) {
      isReadyToAddParent = false;
      canvasWriter.model.updateComponent(selectedComponentId);
    } else {
      if (selectedComponentId != null) {
        hideComponentHighlight(selectedComponentId);
        selectedComponentId = null;
      } else {
        canvasWriter.model.addComponent(
          ComponentData(
            size: sizes[math.Random().nextInt(sizes.length)],
            minSize: Size(72, 48),
            position:
                canvasReader.state.fromCanvasCoordinates(details.localPosition),
            data: MyComponentData(),
          ),
        );
      }
    }
  }
}
