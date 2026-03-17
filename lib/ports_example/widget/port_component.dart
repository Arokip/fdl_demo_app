import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class PortComponent extends StatelessWidget {
  final ComponentData<dynamic> componentData;

  const PortComponent({super.key,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    final PortData portData = componentData.data;

    return switch (portData.portState) {
      PortState.hidden => const SizedBox.shrink(),
      PortState.shown => Port(
          color: portData.color,
          borderColor: Colors.black,
        ),
      PortState.selected => Port(
          color: portData.color,
          borderColor: Colors.cyan,
        ),
      PortState.highlighted => Port(
          color: portData.color,
          borderColor: Colors.amber,
        ),
    };
  }
}

class Port extends StatelessWidget {
  final Color color;
  final Color borderColor;

  const Port({super.key,
    this.color = Colors.white,
    this.borderColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: borderColor,
        ),
      ),
    );
  }
}

enum PortState { hidden, shown, selected, highlighted }

enum PortType { R, G, B }

class PortData {
  final PortType type;
  final Color color;
  final Size size;
  final Alignment alignmentOnComponent;

  PortState portState = PortState.shown;

  PortData({
    required this.type,
    required this.color,
    required this.size,
    required this.alignmentOnComponent,
  });

  setPortState(PortState portState) {
    this.portState = portState;
  }
}
