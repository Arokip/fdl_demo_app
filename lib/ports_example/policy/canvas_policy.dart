import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/policy/custom_policy.dart';
import 'package:diagram_editor_apps/ports_example/widget/port_component.dart';
import 'package:diagram_editor_apps/ports_example/widget/rect_component.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    canvasWriter.model.hideAllLinkJoints();

    if (selectedPortId == null) {
      _addComponentDataWithPorts(
          canvasReader.state.fromCanvasCoordinates(details.localPosition));
    }
    deselectAllPorts();
  }

  _addComponentDataWithPorts(Offset position) {
    String type = componentTypes[math.Random().nextInt(componentTypes.length)];

    var componentData = _getComponentData(type, position);
    canvasWriter.model.addComponent(componentData);
    int zOrder = canvasWriter.model.moveComponentToTheFront(componentData.id);
    componentData.data.portData.forEach((PortData port) {
      var newPort = ComponentData(
        size: port.size,
        type: 'port',
        data: port,
        position: componentData.position +
            componentData.getPointOnComponent(port.alignmentOnComponent) -
            port.size.center(Offset.zero),
      );
      canvasWriter.model.addComponent(newPort);
      canvasWriter.model.setComponentParent(newPort.id, componentData.id);
      newPort.zOrder = zOrder + 1;
    });
  }

  ComponentData _getComponentData(String type, Offset position) {
    var portComponent = ComponentData(
      size: Size(120, 120),
      position: position,
      type: 'component',
      data: MyComponentData(
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
      ),
    );

    switch (type) {
      case 'center':
        portComponent.data.portData.add(_getPortData(Alignment.center));
        break;
      case 'zero-one':
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        break;
      case 'one_zero':
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        break;
      case 'one-one':
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        break;
      case 'one-two':
        portComponent.data.portData.add(_getPortData(Alignment.centerLeft));
        portComponent.data.portData.add(_getPortData(Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(Alignment(1, 0.5)));
        break;
      case 'two-one':
        portComponent.data.portData.add(_getPortData(Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        break;
      case 'two-two':
        portComponent.data.portData.add(_getPortData(Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(Alignment(1, 0.5)));
        break;
      case 'corners':
        portComponent.data.portData.add(_getPortData(Alignment.topLeft));
        portComponent.data.portData.add(_getPortData(Alignment.topRight));
        portComponent.data.portData.add(_getPortData(Alignment.bottomRight));
        portComponent.data.portData.add(_getPortData(Alignment.bottomLeft));
        break;
      default:
        break;
    }
    return portComponent;
  }

  PortData _getPortData(Alignment alignment) {
    var portType = ['R', 'G', 'B'][math.Random().nextInt(3)];
    Color portColor;
    switch (portType) {
      case 'R':
        portColor = Colors.red;
        break;
      case 'G':
        portColor = Colors.green;
        break;
      case 'B':
        portColor = Colors.blue;
        break;
    }
    var portData = PortData(
      type: portType,
      color: portColor,
      size: Size(20, 20),
      alignmentOnComponent: alignment,
    );
    portData.setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
    return portData;
  }
}
