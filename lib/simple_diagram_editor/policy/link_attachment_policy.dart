import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

/// Attach to border, depends on shape
mixin MyLinkAttachmentPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentData componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint -
        (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'oval':
        Offset pointAlignment = pointPosition / pointPosition.distance;

        return Alignment(pointAlignment.dx, pointAlignment.dy);
        break;
      case 'crystal':
        Offset pointAlignment =
            pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

        return Alignment(pointAlignment.dx, pointAlignment.dy);
        break;

      default:
        Offset pointAlignment;
        if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dx.abs(),
              pointPosition.dy / pointPosition.dx.abs());
        } else {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dy.abs(),
              pointPosition.dy / pointPosition.dy.abs());
        }
        return Alignment(pointAlignment.dx, pointAlignment.dy);
        break;
    }
  }
}
