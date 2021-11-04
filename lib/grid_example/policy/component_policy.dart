import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/grid_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

enum Movement { topLeft, topRight, bottomLeft, bottomRight }

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  late Offset startFocalPosition;
  late Offset startComponentPosition;
  Offset lastPositionChange = Offset.zero;
  Movement movement = Movement.topLeft;

  @override
  onComponentLongPress(String componentId) {
    canvasWriter.model.removeComponent(componentId);
  }

  @override
  onComponentScaleStart(componentId, details) {
    startFocalPosition = details.localFocalPoint;
    startComponentPosition =
        canvasReader.model.getComponent(componentId).position;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionChange = details.localFocalPoint - startFocalPosition;

    Offset newPosition =
        startComponentPosition + (positionChange) / canvasReader.state.scale;

    canvasWriter.model.setComponentPosition(componentId, newPosition);
    if (isSnappingEnabled) {
      var component = canvasReader.model.getComponent(componentId);

      double finalPosX = newPosition.dx;
      double finalPosY = newPosition.dy;

      bool isCloser(double position, [double size = 0]) {
        if (size == 0) {
          return (position) % gridGap < snapSize;
        } else {
          return (position + size + snapSize) % gridGap < snapSize;
        }
      }

      Offset delta = lastPositionChange - positionChange;

      if (delta.dx > 0 && delta.dy > 0) {
        movement = Movement.topLeft;
      } else if (delta.dx < 0 && delta.dy > 0) {
        movement = Movement.topRight;
      } else if (delta.dx > 0 && delta.dy < 0) {
        movement = Movement.bottomLeft;
      } else if (delta.dx < 0 && delta.dy < 0) {
        movement = Movement.bottomRight;
      } else if (delta.dx == 0 && delta.dy > 0) {
        if (movement != Movement.topRight) {
          movement = Movement.topLeft;
        }
      } else if (delta.dx == 0 && delta.dy < 0) {
        if (movement != Movement.bottomRight) {
          movement = Movement.bottomLeft;
        }
      } else if (delta.dy == 0 && delta.dx > 0) {
        if (movement != Movement.bottomLeft) {
          movement = Movement.topLeft;
        }
      } else if (delta.dy == 0 && delta.dx < 0) {
        if (movement != Movement.bottomRight) {
          movement = Movement.topRight;
        }
      }

      switch (movement) {
        case Movement.topLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.topRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.bottomLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
        case Movement.bottomRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
      }

      canvasWriter.model.setComponentPosition(
          componentId,
          Offset(
            finalPosX,
            finalPosY,
          ));
    }
    lastPositionChange = positionChange;
  }

  @override
  onComponentScaleEnd(String componentId, ScaleEndDetails details) {
    lastPositionChange = Offset.zero;
  }
}
