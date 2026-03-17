import 'package:flutter/material.dart';

class SnapSwitch extends StatelessWidget {
  final bool isSnappingEnabled;
  final VoidCallback onToggle;

  const SnapSwitch({
    super.key,
    required this.isSnappingEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 100,
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 200,
          height: 32,
          color: Colors.amber,
          child: Center(
            child: Text(
              isSnappingEnabled
                  ? 'grid snapping ENABLED'
                  : 'grid snapping DISABLED',
            ),
          ),
        ),
      ),
    );
  }
}
