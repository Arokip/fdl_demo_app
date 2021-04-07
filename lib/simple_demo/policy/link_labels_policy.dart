import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin LinkLabelsPolicy implements LinkWidgetsPolicy {
  List<Widget> showCustomWidgetWithLinkData(
      BuildContext context, LinkData linkData) {
    double linkLabelSize = 32;
    var linkStartLabelPosition = labelPosition(
      linkData.linkPoints.first,
      linkData.linkPoints[1],
      linkLabelSize / 2,
      false,
    );
    var linkEndLabelPosition = labelPosition(
      linkData.linkPoints.last,
      linkData.linkPoints[linkData.linkPoints.length - 2],
      linkLabelSize / 2,
      true,
    );

    return [
      label(
        linkStartLabelPosition,
        linkData.data.startLabel,
        linkLabelSize,
      ),
      label(
        linkEndLabelPosition,
        linkData.data.endLabel,
        linkLabelSize,
      ),
    ];
  }

  Widget label(Offset position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * canvasReader.state.scale,
      height: size * canvasReader.state.scale,
      child: Container(
        child: GestureDetector(
          onTap: () {},
          onLongPress: () {},
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10 * canvasReader.state.scale,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset labelPosition(
    Offset point1,
    Offset point2,
    double labelSize,
    bool left,
  ) {
    var normalized = VectorUtils.normalizeVector(point2 - point1);

    return canvasReader.state.toCanvasCoordinates(point1 -
        Offset(labelSize, labelSize) +
        normalized * labelSize +
        VectorUtils.getPerpendicularVectorToVector(normalized, left) *
            labelSize);
  }
}
