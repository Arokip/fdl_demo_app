import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class PortComponent extends StatelessWidget {
  final ComponentData componentData;

  const PortComponent({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PortData portData = componentData.data;

    switch (portData.portState) {
      case PortState.hidden:
        return SizedBox.shrink();
      case PortState.shown:
        return Port(
          color: portData.color,
          borderColor: Colors.black,
        );
      case PortState.selected:
        return Port(
          color: portData.color,
          borderColor: Colors.cyan,
        );
      case PortState.highlighted:
        return Port(
          color: portData.color,
          borderColor: Colors.amber,
        );
    }
  }
}

class Port extends StatelessWidget {
  final Color color;
  final Color borderColor;

  const Port({
    Key? key,
    this.color = Colors.white,
    this.borderColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.color,
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: this.borderColor,
        ),
      ),
    );
  }
}

enum PortState { hidden, shown, selected, highlighted }

class PortData {
  final String type;
  final Color color;
  final Size size;
  final Alignment alignmentOnComponent;

  PortState portState = PortState.shown;

  PortData({
    required this.type,
    required this.color,
    this.size = const Size(20, 20),
    this.alignmentOnComponent = Alignment.center,
  });

  setPortState(PortState portState) {
    this.portState = portState;
  }
}
