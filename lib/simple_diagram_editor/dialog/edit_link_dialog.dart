import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_link_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditLinkDialog(
  BuildContext context,
  LinkData<MyLinkData> linkData,
  DiagramController<dynamic, MyLinkData> controller,
) {
  final customData = linkData.data;

  Color color = linkData.linkStyle.color;
  LineType lineTypeDropdown = linkData.linkStyle.lineType;
  double lineWidthPick = linkData.linkStyle.lineWidth;
  const double maxLineWidth = 10;
  const double minLineWidth = 0.1;
  const double widthDelta = 0.1;

  ArrowType arrowTypeDropdown = linkData.linkStyle.arrowType;
  double arrowSizePick = linkData.linkStyle.arrowSize;
  ArrowType backArrowTypeDropdown = linkData.linkStyle.backArrowType;
  double backArrowSizePick = linkData.linkStyle.backArrowSize;
  const double maxArrowSize = 15;
  const double minArrowSize = 1;
  const double arrowSizeDelta = 0.1;

  bool isLineEditShown = false;
  bool isFrontArrowEditShown = false;
  bool isBackArrowEditShown = false;
  bool isColorEditShown = false;
  bool isLabelsEditShown = false;

  final startLabelController =
      TextEditingController(text: customData?.startLabel ?? '');
  final endLabelController =
      TextEditingController(text: customData?.endLabel ?? '');

  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 600),
                const Text('Edit link style',
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                ShowItem(
                  text: 'Line',
                  isShown: isLineEditShown,
                  onTap: () => setState(
                      () => isLineEditShown = !isLineEditShown),
                ),
                Visibility(
                  visible: isLineEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<LineType>(
                        value: lineTypeDropdown,
                        onChanged: (LineType? newValue) {
                          if (newValue != null) {
                            setState(() => lineTypeDropdown = newValue);
                          }
                        },
                        items: LineType.values.map((LineType lineType) {
                          return DropdownMenuItem<LineType>(
                            value: lineType,
                            child: Text(lineType.toString()),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _circleButton(Icons.remove, () {
                            setState(() {
                              lineWidthPick = (lineWidthPick - widthDelta)
                                  .clamp(minLineWidth, maxLineWidth);
                            });
                          }),
                          Column(
                            children: [
                              Text(lineWidthPick.toStringAsFixed(1)),
                              Slider(
                                value: lineWidthPick,
                                onChanged: (double newValue) {
                                  setState(() {
                                    lineWidthPick = double.parse(
                                        newValue.toStringAsFixed(1));
                                  });
                                },
                                min: minLineWidth,
                                max: maxLineWidth,
                              ),
                            ],
                          ),
                          _circleButton(Icons.add, () {
                            setState(() {
                              lineWidthPick = (lineWidthPick + widthDelta)
                                  .clamp(minLineWidth, maxLineWidth);
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                  text: 'Front arrow',
                  isShown: isFrontArrowEditShown,
                  onTap: () => setState(() =>
                      isFrontArrowEditShown = !isFrontArrowEditShown),
                ),
                Visibility(
                  visible: isFrontArrowEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<ArrowType>(
                        value: arrowTypeDropdown,
                        onChanged: (ArrowType? newValue) {
                          if (newValue != null) {
                            setState(
                                () => arrowTypeDropdown = newValue);
                          }
                        },
                        items:
                            ArrowType.values.map((ArrowType arrowType) {
                          return DropdownMenuItem<ArrowType>(
                            value: arrowType,
                            child: Text('$arrowType'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _circleButton(Icons.remove, () {
                            setState(() {
                              arrowSizePick =
                                  (arrowSizePick - arrowSizeDelta)
                                      .clamp(
                                          minArrowSize, maxArrowSize);
                            });
                          }),
                          Column(
                            children: [
                              Text(arrowSizePick.toStringAsFixed(1)),
                              Slider(
                                value: arrowSizePick,
                                onChanged: (double newValue) {
                                  setState(() {
                                    arrowSizePick = double.parse(
                                        newValue.toStringAsFixed(1));
                                  });
                                },
                                min: minArrowSize,
                                max: maxArrowSize,
                              ),
                            ],
                          ),
                          _circleButton(Icons.add, () {
                            setState(() {
                              arrowSizePick =
                                  (arrowSizePick + arrowSizeDelta)
                                      .clamp(
                                          minArrowSize, maxArrowSize);
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                  text: 'Back arrow',
                  isShown: isBackArrowEditShown,
                  onTap: () => setState(() =>
                      isBackArrowEditShown = !isBackArrowEditShown),
                ),
                Visibility(
                  visible: isBackArrowEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<ArrowType>(
                        value: backArrowTypeDropdown,
                        onChanged: (ArrowType? newValue) {
                          if (newValue != null) {
                            setState(
                                () => backArrowTypeDropdown = newValue);
                          }
                        },
                        items:
                            ArrowType.values.map((ArrowType arrowType) {
                          return DropdownMenuItem<ArrowType>(
                            value: arrowType,
                            child: Text('$arrowType'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _circleButton(Icons.remove, () {
                            setState(() {
                              backArrowSizePick =
                                  (backArrowSizePick - arrowSizeDelta)
                                      .clamp(
                                          minArrowSize, maxArrowSize);
                            });
                          }),
                          Column(
                            children: [
                              Text(
                                  backArrowSizePick.toStringAsFixed(1)),
                              Slider(
                                value: backArrowSizePick,
                                onChanged: (double newValue) {
                                  setState(() {
                                    backArrowSizePick = double.parse(
                                        newValue.toStringAsFixed(1));
                                  });
                                },
                                min: minArrowSize,
                                max: maxArrowSize,
                              ),
                            ],
                          ),
                          _circleButton(Icons.add, () {
                            setState(() {
                              backArrowSizePick =
                                  (backArrowSizePick + arrowSizeDelta)
                                      .clamp(
                                          minArrowSize, maxArrowSize);
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                  text: 'Link color',
                  isShown: isColorEditShown,
                  onTap: () => setState(
                      () => isColorEditShown = !isColorEditShown),
                ),
                Visibility(
                  visible: isColorEditShown,
                  child: Row(
                    children: [
                      const Text('Color:'),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () async {
                          final pickedColor = showPickColorDialog(
                              context, color, 'Pick a line color');
                          color = await pickedColor;
                          setState(() {});
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                  text: 'Link labels',
                  isShown: isLabelsEditShown,
                  onTap: () => setState(
                      () => isLabelsEditShown = !isLabelsEditShown),
                ),
                Visibility(
                  visible: isLabelsEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: startLabelController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Start label',
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 13),
                        ),
                      ),
                      TextField(
                        controller: endLabelController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'End label',
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            scrollable: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('DISCARD'),
              ),
              TextButton(
                onPressed: () {
                  // Update custom data (labels)
                  if (customData != null) {
                    customData.startLabel = startLabelController.text;
                    customData.endLabel = endLabelController.text;
                  }

                  // Since LinkStyle is immutable, recreate the link
                  final newStyle = LinkStyle(
                    color: color,
                    lineType: lineTypeDropdown,
                    lineWidth: lineWidthPick,
                    arrowType: arrowTypeDropdown,
                    arrowSize: arrowSizePick,
                    backArrowType: backArrowTypeDropdown,
                    backArrowSize: backArrowSizePick,
                  );

                  // Save link info before removing
                  final sourceId = linkData.sourceComponentId;
                  final targetId = linkData.targetComponentId;
                  final points = linkData.getLinkPoints();
                  final middlePoints = points.length > 2
                      ? points.sublist(1, points.length - 1)
                      : <Offset>[];
                  final linkCustomData = customData != null
                      ? MyLinkData.copy(customData)
                      : MyLinkData();
                  linkCustomData.startLabel = startLabelController.text;
                  linkCustomData.endLabel = endLabelController.text;

                  // Remove old link and create new one with updated style
                  controller.removeLink(linkData.id);
                  final newLinkId = controller.connect(
                    sourceComponentId: sourceId,
                    targetComponentId: targetId,
                    linkStyle: newStyle,
                    data: linkCustomData,
                  );

                  // Restore middle points (joints)
                  for (int i = 0; i < middlePoints.length; i++) {
                    controller.insertLinkJoint(
                        newLinkId, middlePoints[i], i + 1);
                  }

                  Navigator.of(context).pop();
                },
                child: const Text('SAVE'),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _circleButton(IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      width: 32,
      height: 32,
      child: Center(child: Icon(icon, size: 12)),
    ),
  );
}

class ShowItem extends StatelessWidget {
  final String text;
  final bool isShown;
  final VoidCallback onTap;

  const ShowItem({
    super.key,
    required this.text,
    required this.isShown,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(text),
          Icon(isShown
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
