import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_link_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditLinkDialog(BuildContext context, LinkData linkData) {
  MyLinkData customData = linkData.data;

  Color color = linkData.linkStyle.color;
  LineType lineTypeDropdown = linkData.linkStyle.lineType;
  double lineWidthPick = linkData.linkStyle.lineWidth;
  double maxLineWidth = 10;
  double minLineWidth = 0.1;
  double widthDelta = 0.1;

  ArrowType arrowTypeDropdown = linkData.linkStyle.arrowType;
  double arrowSizePick = linkData.linkStyle.arrowSize;
  ArrowType backArrowTypeDropdown = linkData.linkStyle.backArrowType;
  double backArrowSizePick = linkData.linkStyle.backArrowSize;
  double maxArrowSize = 15;
  double minArrowSize = 1;
  double arrowSizeDelta = 0.1;

  bool isLineEditShown = false;
  bool isFrontArrowEditShown = false;
  bool isBackArrowEditShown = false;
  bool isColorEditShown = false;
  bool isLabelsEditShown = false;

  final startLabelController =
      TextEditingController(text: customData.startLabel ?? '');
  final endLabelController =
      TextEditingController(text: customData.endLabel ?? '');

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
                SizedBox(width: 600),
                Text('Edit link style', style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                ShowItem(
                    text: 'Line',
                    isShown: isLineEditShown,
                    onTap: () =>
                        setState(() => isLineEditShown = !isLineEditShown)),
                Visibility(
                  visible: isLineEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: DropdownButton<LineType>(
                          value: lineTypeDropdown,
                          onChanged: (LineType newValue) {
                            setState(() {
                              lineTypeDropdown = newValue;
                            });
                          },
                          items: LineType.values.map((LineType lineType) {
                            return DropdownMenuItem<LineType>(
                              value: lineType,
                              child: Text(lineType.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                lineWidthPick -= widthDelta;
                                if (lineWidthPick > maxLineWidth) {
                                  lineWidthPick = maxLineWidth;
                                } else if (lineWidthPick < minLineWidth) {
                                  lineWidthPick = minLineWidth;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child: Center(
                                    child: Icon(Icons.remove, size: 12))),
                          ),
                          Column(
                            children: [
                              Text(
                                  '${double.parse(lineWidthPick.toStringAsFixed(1))}'),
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                lineWidthPick += widthDelta;
                                if (lineWidthPick > maxLineWidth) {
                                  lineWidthPick = maxLineWidth;
                                } else if (lineWidthPick < minLineWidth) {
                                  lineWidthPick = minLineWidth;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child:
                                    Center(child: Icon(Icons.add, size: 12))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                    text: 'Front arrow',
                    isShown: isFrontArrowEditShown,
                    onTap: () => setState(
                        () => isFrontArrowEditShown = !isFrontArrowEditShown)),
                Visibility(
                  visible: isFrontArrowEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: DropdownButton<ArrowType>(
                          value: arrowTypeDropdown,
                          onChanged: (ArrowType newValue) {
                            setState(() {
                              arrowTypeDropdown = newValue;
                            });
                          },
                          items: ArrowType.values.map((ArrowType arrowType) {
                            return DropdownMenuItem<ArrowType>(
                              value: arrowType,
                              child: Text('$arrowType'),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                arrowSizePick -= arrowSizeDelta;
                                if (arrowSizePick > maxArrowSize) {
                                  arrowSizePick = maxArrowSize;
                                } else if (arrowSizePick < minArrowSize) {
                                  arrowSizePick = minArrowSize;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child: Center(
                                    child: Icon(Icons.remove, size: 12))),
                          ),
                          Column(
                            children: [
                              Text(
                                  '${double.parse(arrowSizePick.toStringAsFixed(1))}'),
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                arrowSizePick += arrowSizeDelta;
                                if (arrowSizePick > maxArrowSize) {
                                  arrowSizePick = maxArrowSize;
                                } else if (arrowSizePick < minArrowSize) {
                                  arrowSizePick = minArrowSize;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child:
                                    Center(child: Icon(Icons.add, size: 12))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                    text: 'Back arrow',
                    isShown: isBackArrowEditShown,
                    onTap: () => setState(
                        () => isBackArrowEditShown = !isBackArrowEditShown)),
                Visibility(
                  visible: isBackArrowEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: DropdownButton<ArrowType>(
                          value: backArrowTypeDropdown,
                          onChanged: (ArrowType newValue) {
                            setState(() {
                              backArrowTypeDropdown = newValue;
                            });
                          },
                          items: ArrowType.values.map((ArrowType arrowType) {
                            return DropdownMenuItem<ArrowType>(
                              value: arrowType,
                              child: Text('$arrowType'),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                backArrowSizePick -= arrowSizeDelta;
                                if (backArrowSizePick > maxArrowSize) {
                                  backArrowSizePick = maxArrowSize;
                                } else if (backArrowSizePick < minArrowSize) {
                                  backArrowSizePick = minArrowSize;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child: Center(
                                    child: Icon(Icons.remove, size: 12))),
                          ),
                          Column(
                            children: [
                              Text(
                                  '${double.parse(backArrowSizePick.toStringAsFixed(1))}'),
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                backArrowSizePick += arrowSizeDelta;
                                if (backArrowSizePick > maxArrowSize) {
                                  backArrowSizePick = maxArrowSize;
                                } else if (backArrowSizePick < minArrowSize) {
                                  backArrowSizePick = minArrowSize;
                                }
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                width: 32,
                                height: 32,
                                child:
                                    Center(child: Icon(Icons.add, size: 12))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                    text: 'Link color',
                    isShown: isColorEditShown,
                    onTap: () =>
                        setState(() => isColorEditShown = !isColorEditShown)),
                Visibility(
                  visible: isColorEditShown,
                  child: Row(
                    children: [
                      Text('Color:'),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () async {
                          var pickedColor =
                              // showPickColorDialog(context, linkData);
                              showPickColorDialog(
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
                Divider(color: Colors.black, height: 8, thickness: 1),
                ShowItem(
                    text: 'Link labels',
                    isShown: isLabelsEditShown,
                    onTap: () =>
                        setState(() => isLabelsEditShown = !isLabelsEditShown)),
                Visibility(
                  visible: isLabelsEditShown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: startLabelController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Start label',
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 13),
                        ),
                      ),
                      TextField(
                        controller: endLabelController,
                        maxLines: 1,
                        decoration: InputDecoration(
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('DISCARD'),
              ),
              TextButton(
                onPressed: () {
                  linkData.linkStyle.color = color;
                  linkData.linkStyle.lineType = lineTypeDropdown;
                  linkData.linkStyle.lineWidth = lineWidthPick;
                  linkData.linkStyle.arrowType = arrowTypeDropdown;
                  linkData.linkStyle.arrowSize = arrowSizePick;
                  linkData.linkStyle.backArrowType = backArrowTypeDropdown;
                  linkData.linkStyle.backArrowSize = backArrowSizePick;
                  customData.startLabel = startLabelController.text;
                  customData.endLabel = endLabelController.text;
                  linkData.updateLink();
                  Navigator.of(context).pop();
                },
                child: Text('SAVE'),
              )
            ],
          );
        },
      );
    },
  );
}

class ShowItem extends StatelessWidget {
  final String text;
  final bool isShown;
  final Function onTap;

  const ShowItem({Key key, this.text, this.isShown, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        children: [
          Text(text),
          Icon(isShown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
