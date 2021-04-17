import 'dart:math' as math;
import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) async {
    canvasWriter.model.addComponent(
      ComponentData(
        size: Size(
          math.Random().nextInt(160) + 80.0,
          math.Random().nextInt(160) + 80.0,
        ),
        position:
            canvasReader.state.fromCanvasCoordinates(details.localPosition),
      ),
    );
  }
}
