import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/widget/port_component.dart';
import 'package:diagram_editor_apps/ports_example/widget/port_switch.dart';
import 'package:diagram_editor_apps/ports_example/widget/rect_component.dart';
import 'package:flutter/material.dart';

class PortsDiagramEditor extends StatefulWidget {
  const PortsDiagramEditor({super.key});

  @override
  PortsDiagramEditorState createState() => PortsDiagramEditorState();
}

class PortsDiagramEditorState extends State<PortsDiagramEditor> {
  final DiagramController<dynamic, void> controller = DiagramController<dynamic, void>(
    canvasConfig: const CanvasConfig(
      backgroundColor: Color(0xFFE0E0E0),
    ),
  );

  final List<String> componentTypes = [
    'center',
    'zero-one',
    'one_zero',
    'one-one',
    'one-two',
    'two-one',
    'two-two',
    'corners',
  ];

  String? selectedPortId;
  bool arePortsVisible = true;
  Offset lastFocalPoint = Offset.zero;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Port connection logic
  // ---------------------------------------------------------------------------

  bool canConnectThesePorts(String? portId1, String? portId2) {
    if (portId1 == null || portId2 == null) return false;
    if (portId1 == portId2) return false;

    var port1 = controller.getComponent(portId1);
    var port2 = controller.getComponent(portId2);

    if (port1.type != 'port' || port2.type != 'port') return false;
    if ((port1.data as PortData).type != (port2.data as PortData).type) return false;
    if (port1.connections.any((connection) => connection.otherComponentId == portId2)) return false;
    if (port1.parentId == port2.parentId) return false;

    return true;
  }

  void selectPort(String portId) {
    var port = controller.getComponent(portId);
    (port.data as PortData).setPortState(PortState.selected);
    port.updateComponent();
    selectedPortId = portId;

    for (final port in controller.components.values) {
      if (canConnectThesePorts(portId, port.id)) {
        (port.data as PortData).setPortState(PortState.highlighted);
        port.updateComponent();
      }
    }
  }

  void deselectAllPorts() {
    selectedPortId = null;

    for (final component in controller.components.values) {
      if (component.type == 'port') {
        (component.data as PortData).setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
        component.updateComponent();
      }
    }
  }

  void switchPortsVisibility() {
    selectedPortId = null;
    arePortsVisible = !arePortsVisible;

    for (final component in controller.components.values) {
      if (component.type == 'port') {
        (component.data as PortData).setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
        component.updateComponent();
      }
    }
  }

  void deleteAllComponents() {
    controller.removeAllComponents();
  }

  bool connectComponents(String? sourceComponentId, String? targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) return false;
    if (!canConnectThesePorts(sourceComponentId, targetComponentId)) return false;

    controller.connect(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: const LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
      ),
    );

    return true;
  }

  // ---------------------------------------------------------------------------
  // Component creation
  // ---------------------------------------------------------------------------

  void addComponentDataWithPorts(Offset position) {
    String type = componentTypes[math.Random().nextInt(componentTypes.length)];

    var componentData = _getComponentData(type, position);
    controller.addComponent(componentData);
    int zOrder = controller.bringToFront(componentData.id);
    for (final port in (componentData.data as MyComponentData).portData) {
      var newPort = ComponentData<dynamic>(
        size: port.size,
        type: 'port',
        data: port,
        position: componentData.position +
            componentData.getPointOnComponent(port.alignmentOnComponent) -
            port.size.center(Offset.zero),
      );
      controller.addComponent(newPort);
      controller.setComponentParent(newPort.id, componentData.id);
      newPort.zOrder = zOrder + 1;
    }
  }

  ComponentData<dynamic> _getComponentData(String type, Offset position) {
    var portComponent = ComponentData<dynamic>(
      size: const Size(120, 120),
      position: position,
      type: 'component',
      data: MyComponentData(
        color: Color.fromARGB(255, math.Random().nextInt(256), math.Random().nextInt(256), math.Random().nextInt(256)),
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
        portComponent.data.portData.add(_getPortData(const Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, 0.5)));
        break;
      case 'two-one':
        portComponent.data.portData.add(_getPortData(const Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(Alignment.centerRight));
        break;
      case 'two-two':
        portComponent.data.portData.add(_getPortData(const Alignment(-1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(-1, 0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, -0.5)));
        portComponent.data.portData.add(_getPortData(const Alignment(1, 0.5)));
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
    var portType = PortType.values[math.Random().nextInt(3)];
    final portColor = switch (portType) {
      PortType.R => Colors.red,
      PortType.G => Colors.green,
      PortType.B => Colors.blue,
    };
    var portData = PortData(
      type: portType,
      color: portColor,
      size: const Size(20, 20),
      alignmentOnComponent: alignment,
    );
    portData.setPortState(arePortsVisible ? PortState.shown : PortState.hidden);
    return portData;
  }

  // ---------------------------------------------------------------------------
  // Callbacks
  // ---------------------------------------------------------------------------

  void _onCanvasTapUp(TapUpDetails details) {
    controller.hideAllLinkJoints();

    if (selectedPortId == null) {
      addComponentDataWithPorts(controller.fromCanvasCoordinates(details.localPosition));
    }
    deselectAllPorts();
  }

  void _onComponentTap(String componentId) {
    controller.hideAllLinkJoints();

    var component = controller.getComponent(componentId);

    if (component.type == 'port') {
      bool connected = connectComponents(selectedPortId, componentId);
      deselectAllPorts();
      if (!connected) {
        selectPort(componentId);
      }
    }
  }

  void _onComponentLongPress(String componentId) {
    var component = controller.getComponent(componentId);
    if (component.type == 'component') {
      controller.hideAllLinkJoints();
      controller.removeComponentWithChildren(componentId);
    }
  }

  void _onComponentScaleStart(String componentId, ScaleStartDetails details) {
    lastFocalPoint = details.localFocalPoint;
  }

  void _onComponentScaleUpdate(String componentId, ScaleUpdateDetails details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;

    var component = controller.getComponent(componentId);

    if (component.type == 'component') {
      controller.moveComponentWithChildren(componentId, positionDelta);
    } else if (component.type == 'port' && component.parentId != null) {
      controller.moveComponentWithChildren(component.parentId!, positionDelta);
    }

    lastFocalPoint = details.localFocalPoint;
  }

  // ---------------------------------------------------------------------------
  // Component builder
  // ---------------------------------------------------------------------------

  Widget _componentBuilder(BuildContext context, ComponentData<dynamic> componentData) {
    switch (componentData.type) {
      case 'component':
        return RectComponent(componentData: componentData);
      case 'port':
        return PortComponent(componentData: componentData);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DiagramEditor<dynamic, void>(
                  controller: controller,
                  componentBuilder: _componentBuilder,
                  onCanvasTapUp: _onCanvasTapUp,
                  onComponentTap: _onComponentTap,
                  onComponentLongPress: _onComponentLongPress,
                  onComponentScaleStart: _onComponentScaleStart,
                  onComponentScaleUpdate: _onComponentScaleUpdate,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => deleteAllComponents(),
                  child: Container(
                    width: 80,
                    height: 32,
                    color: Colors.red,
                    child: const Center(child: Text('delete all')),
                  ),
                ),
              ),
              PortSwitch(
                arePortsVisible: arePortsVisible,
                onToggle: () {
                  switchPortsVisibility();
                  setState(() {});
                },
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('BACK TO MENU'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
