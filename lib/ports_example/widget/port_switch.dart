import 'package:flutter/material.dart';

class PortSwitch extends StatelessWidget {
  final bool arePortsVisible;
  final VoidCallback onToggle;

  const PortSwitch({
    super.key,
    required this.arePortsVisible,
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
          width: 96,
          height: 32,
          color: Colors.amber,
          child: Center(child: Text(arePortsVisible ? 'hide ports' : 'show ports')),
        ),
      ),
    );
  }
}
