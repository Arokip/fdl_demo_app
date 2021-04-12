import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';
import 'package:diagram_editor_apps/simple_demo/dialog/edit_link_dialog.dart';
import 'package:flutter/material.dart';

mixin MyLinkWidgetsPolicy implements LinkWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showWidgetsWithLinkData(
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
      if (selectedLinkId == linkData.id) showLinkOptions(context, linkData),
    ];
  }

  Widget showLinkOptions(BuildContext context, LinkData linkData) {
    var nPos = canvasReader.state.toCanvasCoordinates(tapLinkPosition);
    return Positioned(
      left: nPos.dx,
      top: nPos.dy,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              canvasWriter.model.removeLink(linkData.id);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: Center(child: Icon(Icons.close, size: 20))),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showEditLinkDialog(
                context,
                linkData,
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: Center(child: Icon(Icons.edit, size: 20))),
          ),
        ],
      ),
    );
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

  // @override
  // Widget showOnLinkTapWidget(
  //     BuildContext context, LinkData linkData, Offset tapPosition) {
  //   return Positioned(
  //     left: tapPosition.dx,
  //     top: tapPosition.dy,
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             canvasWriter.model.removeLink(linkData.id);
  //           },
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.red.withOpacity(0.7),
  //                 shape: BoxShape.circle,
  //               ),
  //               width: 32,
  //               height: 32,
  //               child: Center(child: Icon(Icons.close, size: 20))),
  //         ),
  //         SizedBox(width: 8),
  //         GestureDetector(
  //           onTap: () {
  //             showEditLinkDialog(
  //               context,
  //               linkData,
  //             );
  //           },
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.withOpacity(0.7),
  //                 shape: BoxShape.circle,
  //               ),
  //               width: 32,
  //               height: 32,
  //               child: Center(child: Icon(Icons.edit, size: 20))),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
