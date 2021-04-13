import 'package:flutter/material.dart';

class OptionIcon extends StatelessWidget {
  final Color color;
  final double size;
  final BoxShape shape;
  final String tooltip;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final Function onPressed;

  const OptionIcon({
    Key key,
    this.color = Colors.grey,
    this.size = 40,
    this.shape = BoxShape.circle,
    this.tooltip,
    this.iconData,
    this.iconColor = Colors.black,
    this.iconSize = 20,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        padding: EdgeInsets.all(0),
        icon: Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
