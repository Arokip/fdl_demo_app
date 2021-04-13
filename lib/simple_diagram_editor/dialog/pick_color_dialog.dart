import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color> showPickColorDialog(
    BuildContext context, Color oldColor, String title) async {
  Color currentColor = oldColor;

  await showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick a line color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) => currentColor = color,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              currentColor = oldColor;
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Set color'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return currentColor;
}
