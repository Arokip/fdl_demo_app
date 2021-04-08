import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditLinkDialog(BuildContext context, LinkData linkData) {
  // MyLinkData customData = linkData.data;
  // LinkStyle linkStyle = linkData.linkStyle;

  // TODO: change labels

  Color color = linkData.linkStyle.color;
  LineType lineTypeDropdown = linkData.linkStyle.lineType;
  ArrowType arrowTypeDropdown = linkData.linkStyle.arrowType;
  double arrowSizePick = linkData.linkStyle.arrowSize;
  double lineWidthPick = linkData.linkStyle.lineWidth;

  double maxArrowSize = 15;
  double minArrowSize = 1;
  double arrowSizeDelta = 0.5;
  double maxLineWidth = 10;
  double minLineWidth = 0.1;
  double widthDelta = 0.1;

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
                SizedBox(height: 16),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arrow size:'),
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
                              child:
                                  Center(child: Icon(Icons.remove, size: 12))),
                        ),
                        Column(
                          children: [
                            Text(
                                '${double.parse(arrowSizePick.toStringAsFixed(1))}'),
                            Slider(
                              value: arrowSizePick,
                              onChanged: (double newValue) {
                                setState(() {
                                  arrowSizePick =
                                      double.parse(newValue.toStringAsFixed(1));
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
                              child: Center(child: Icon(Icons.add, size: 12))),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Line width:'),
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
                              child:
                                  Center(child: Icon(Icons.remove, size: 12))),
                        ),
                        Column(
                          children: [
                            Text(
                                '${double.parse(lineWidthPick.toStringAsFixed(1))}'),
                            Slider(
                              value: lineWidthPick,
                              onChanged: (double newValue) {
                                setState(() {
                                  lineWidthPick =
                                      double.parse(newValue.toStringAsFixed(1));
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
                              child: Center(child: Icon(Icons.add, size: 12))),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
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
                  linkData.linkStyle.arrowType = arrowTypeDropdown;
                  linkData.linkStyle.arrowSize = arrowSizePick;
                  linkData.linkStyle.lineWidth = lineWidthPick;

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
