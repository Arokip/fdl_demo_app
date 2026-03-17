import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/component_data.dart';
import 'package:diagram_editor_apps/hierarchical_example/option_icon.dart';
import 'package:flutter/material.dart';

class HierarchicalDiagramEditor extends StatefulWidget {
  const HierarchicalDiagramEditor({super.key});

  @override
  HierarchicalDiagramEditorState createState() =>
      HierarchicalDiagramEditorState();
}

class HierarchicalDiagramEditorState extends State<HierarchicalDiagramEditor> {
  late final DiagramController<MyComponentData, void> controller;

  String? selectedComponentId;
  bool isReadyToAddParent = false;
  late Offset lastFocalPoint;

  final _sizes = [
    const Size(80, 60),
    const Size(200, 150),
  ];

  @override
  void initState() {
    super.initState();
    controller = DiagramController<MyComponentData, void>();
    _initializeDiagram();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initializeDiagram() {
    var cd1 = _getSmallComponentData(const Offset(220, 100));
    var cd2 = _getSmallComponentData(const Offset(220, 180));
    var cd3 = _getSmallComponentData(const Offset(400, 100));
    var cd4 = _getSmallComponentData(const Offset(400, 180));

    var cd5 = _getBigComponentData(const Offset(80, 80));
    var cd6 = _getBigComponentData(const Offset(380, 80));

    controller.addComponent(cd1);
    controller.addComponent(cd2);
    controller.addComponent(cd3);
    controller.addComponent(cd4);
    controller.addComponent(cd5);
    controller.addComponent(cd6);

    controller.bringToFront(cd5.id);
    controller.bringToFront(cd6.id);

    controller.bringToFront(cd1.id);
    controller.bringToFront(cd2.id);
    controller.bringToFront(cd3.id);
    controller.bringToFront(cd4.id);

    controller.setComponentParent(cd1.id, cd5.id);
    controller.setComponentParent(cd2.id, cd5.id);

    controller.setComponentParent(cd3.id, cd6.id);
    controller.setComponentParent(cd4.id, cd6.id);

    controller.connect(
      sourceComponentId: cd1.id,
      targetComponentId: cd3.id,
      linkStyle: const LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
    controller.connect(
      sourceComponentId: cd4.id,
      targetComponentId: cd2.id,
      linkStyle: const LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
  }

  ComponentData<MyComponentData> _getSmallComponentData(Offset position) {
    return ComponentData<MyComponentData>(
      size: const Size(80, 64),
      minSize: const Size(72, 48),
      position: position,
      data: MyComponentData(),
    );
  }

  ComponentData<MyComponentData> _getBigComponentData(Offset position) {
    return ComponentData<MyComponentData>(
      size: const Size(240, 180),
      minSize: const Size(72, 48),
      position: position,
      data: MyComponentData(),
    );
  }

  void _highlightComponent(String componentId) {
    controller.getComponent(componentId).data?.showHighlight();
    controller.getComponent(componentId).updateComponent();
  }

  void _hideComponentHighlight(String? componentId) {
    if (selectedComponentId != null && componentId != null) {
      controller.getComponent(componentId).data?.hideHighlight();
      controller.getComponent(componentId).updateComponent();
    }
  }

  bool _connectComponents(
      String? sourceComponentId, String? targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (controller
        .getComponent(sourceComponentId)
        .connections
        .any((connection) =>
            (connection is OutgoingConnection) &&
            (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    controller.connect(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: const LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );

    return true;
  }

  void _deleteAllComponents() {
    selectedComponentId = null;
    controller.removeAllComponents();
  }

  void _onCanvasTapUp(TapUpDetails details) {
    controller.hideAllLinkJoints();

    if (isReadyToAddParent) {
      isReadyToAddParent = false;
      if (selectedComponentId != null) {
        controller.getComponent(selectedComponentId!).updateComponent();
      }
    } else {
      if (selectedComponentId != null) {
        _hideComponentHighlight(selectedComponentId);
        selectedComponentId = null;
      } else {
        controller.addComponent(
          ComponentData<MyComponentData>(
            size: _sizes[math.Random().nextInt(_sizes.length)],
            minSize: const Size(72, 48),
            position: controller.fromCanvasCoordinates(details.localPosition),
            data: MyComponentData(),
          ),
        );
      }
    }
  }

  void _onComponentTap(String componentId) {
    _hideComponentHighlight(selectedComponentId);
    controller.hideAllLinkJoints();

    if (isReadyToAddParent) {
      if (selectedComponentId != null) {
        controller.setComponentParent(selectedComponentId!, componentId);
      }
      selectedComponentId = null;
      isReadyToAddParent = false;
    } else {
      bool connected = _connectComponents(selectedComponentId, componentId);
      if (connected) {
        selectedComponentId = null;
      } else {
        selectedComponentId = componentId;
        _highlightComponent(componentId);
      }
    }
  }

  void _onComponentScaleStart(String componentId, ScaleStartDetails details) {
    lastFocalPoint = details.localFocalPoint;
  }

  void _onComponentScaleUpdate(String componentId, ScaleUpdateDetails details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    controller.moveComponentWithChildren(componentId, positionDelta);
    lastFocalPoint = details.localFocalPoint;
  }

  Widget _componentBuilder(
      BuildContext context, ComponentData<MyComponentData> component) {
    final text = Text(
      'id: ${component.id.substring(0, 4)}',
      style: const TextStyle(fontSize: 10),
    );
    return Container(
      decoration: BoxDecoration(
        color: component.data?.color,
        border: Border.all(
          width: 2,
          color: (component.data?.isHighlightVisible ?? false)
              ? Colors.pink
              : Colors.black,
        ),
      ),
      child: Center(
        child: isReadyToAddParent
            ? const Text('tap on parent', style: TextStyle(fontSize: 10))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text,
                  Text(
                    component.parentId == null
                        ? 'no parent'
                        : 'parent: ${component.parentId?.substring(0, 4) ?? 'parent id null'}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _componentOverlayBuilder(
      BuildContext context, ComponentData<MyComponentData> component) {
    if (!(component.data?.isHighlightVisible ?? false)) {
      return const SizedBox.shrink();
    }
    final scale = controller.canvasScale;
    return IgnorePointer(
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (component.size.width + 4) * scale,
          height: (component.size.height + 4) * scale,
          color: Colors.pink,
        ),
      ),
    );
  }

  List<Widget> _buildForeground(BuildContext context) {
    final widgets = <Widget>[];

    for (final component in controller.components.values) {
      if (!(component.data?.isHighlightVisible ?? false)) continue;

      widgets.add(_componentTopOptions(component));
      widgets.add(_componentBottomOptions(component));
      widgets.add(_resizeCorner(component));
    }

    return widgets;
  }

  Widget _componentTopOptions(ComponentData<MyComponentData> component) {
    final pos = controller.toCanvasCoordinates(component.position);
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              controller.removeComponent(component.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.person_add,
            tooltip: 'add parent',
            size: 40,
            onPressed: () {
              isReadyToAddParent = true;
              component.updateComponent();
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.person_remove,
            tooltip: 'remove parent',
            size: 40,
            onPressed: () {
              controller.removeComponentParent(component.id);
              component.updateComponent();
            },
          ),
        ],
      ),
    );
  }

  Widget _componentBottomOptions(ComponentData<MyComponentData> component) {
    final scale = controller.canvasScale;
    final pos = controller.toCanvasCoordinates(component.position);
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy + component.size.height * scale + 8,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => controller.bringToFront(component.id),
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => controller.sendToBack(component.id),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _resizeCorner(ComponentData<MyComponentData> component) {
    final pos = controller.toCanvasCoordinates(
      component.position + component.size.bottomRight(Offset.zero),
    );
    return Positioned(
      left: pos.dx - 12,
      top: pos.dy - 12,
      child: GestureDetector(
        onPanUpdate: (details) {
          controller.resizeComponent(
              component.id, details.delta / controller.canvasScale);
          controller.updateLinks(component.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 24,
            height: 24,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                child: DiagramEditor<MyComponentData, void>(
                  controller: controller,
                  componentBuilder: _componentBuilder,
                  componentOverlayBuilder: _componentOverlayBuilder,
                  foregroundBuilder: _buildForeground,
                  onCanvasTapUp: _onCanvasTapUp,
                  onComponentTap: _onComponentTap,
                  onComponentScaleStart: _onComponentScaleStart,
                  onComponentScaleUpdate: _onComponentScaleUpdate,
                ),
              ),
              GestureDetector(
                onTap: () => _deleteAllComponents(),
                child: Container(
                  width: 80,
                  height: 32,
                  color: Colors.red,
                  child: const Center(child: Text('delete all')),
                ),
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
