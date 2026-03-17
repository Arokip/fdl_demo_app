import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_link_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/edit_component_dialog.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/edit_link_dialog.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/bean_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/bean_left_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/bean_right_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/bend_left_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/bend_right_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/crystal_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/document_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/hexagon_horizontal_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/hexagon_vertical_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/no_corner_rect_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/oval_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/rect_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/rhomboid_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/round_rect_component.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/menu.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/option_icon.dart';
import 'package:flutter/material.dart';

class SimpleDemoEditor extends StatefulWidget {
  const SimpleDemoEditor({super.key});

  @override
  SimpleDemoEditorState createState() => SimpleDemoEditorState();
}

class SimpleDemoEditorState extends State<SimpleDemoEditor> {
  // Controller
  final controller = DiagramController<MyComponentData, MyLinkData>(
    canvasConfig: const CanvasConfig(backgroundColor: Colors.white),
    linkEndpointAligner: _linkEndpointAligner,
  );

  @override
  void dispose() {
    _miniMapTransformController.dispose();
    controller.dispose();
    super.dispose();
  }

  // UI visibility state
  bool isMiniMapVisible = true;
  bool isMenuVisible = true;
  bool isOptionsVisible = true;
  bool isGridVisible = true;

  // Component types available in the menu
  static const List<String> bodies = [
    'junction',
    'rect',
    'round_rect',
    'oval',
    'crystal',
    'rhomboid',
    'bean',
    'bean_left',
    'bean_right',
    'document',
    'hexagon_horizontal',
    'hexagon_vertical',
    'bend_left',
    'bend_right',
    'no_corner_rect',
  ];

  // Selection state
  String? selectedComponentId;
  bool isMultipleSelectionOn = false;
  List<String> multipleSelected = [];
  bool isReadyToConnect = false;

  // Link interaction state
  String? selectedLinkId;
  Offset tapLinkPosition = Offset.zero;
  int? segmentIndex;

  // Component drag state
  late Offset lastFocalPoint;

  // Custom link attachment based on component shape
  static Alignment _linkEndpointAligner(
    ComponentData<dynamic> componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint -
        (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'oval':
      case 'junction':
        final pointAlignment = pointPosition / pointPosition.distance;
        return Alignment(pointAlignment.dx, pointAlignment.dy);
      case 'crystal':
        final pointAlignment = pointPosition /
            (pointPosition.dx.abs() + pointPosition.dy.abs());
        return Alignment(pointAlignment.dx, pointAlignment.dy);
      default:
        Offset pointAlignment;
        if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
          pointAlignment = Offset(
            pointPosition.dx / pointPosition.dx.abs(),
            pointPosition.dy / pointPosition.dx.abs(),
          );
        } else {
          pointAlignment = Offset(
            pointPosition.dx / pointPosition.dy.abs(),
            pointPosition.dy / pointPosition.dy.abs(),
          );
        }
        return Alignment(pointAlignment.dx, pointAlignment.dy);
    }
  }

  // -- Highlight helpers --

  void hideAllHighlights() {
    controller.hideAllLinkJoints();
    hideLinkOption();
    for (final component in controller.components.values) {
      if (component.data?.isHighlightVisible ?? false) {
        component.data!.hideHighlight();
        controller.updateComponent(component.id);
      }
    }
  }

  void highlightComponent(String componentId) {
    controller.getComponent(componentId).data?.showHighlight();
    controller.getComponent(componentId).updateComponent();
  }

  void hideComponentHighlight(String componentId) {
    controller.getComponent(componentId).data?.hideHighlight();
    controller.getComponent(componentId).updateComponent();
  }

  // -- Multi-selection helpers --

  void turnOnMultipleSelection() {
    isMultipleSelectionOn = true;
    isReadyToConnect = false;
    if (selectedComponentId != null) {
      addComponentToMultipleSelection(selectedComponentId!);
      selectedComponentId = null;
    }
  }

  void turnOffMultipleSelection() {
    isMultipleSelectionOn = false;
    multipleSelected = [];
    hideAllHighlights();
  }

  void addComponentToMultipleSelection(String componentId) {
    if (!multipleSelected.contains(componentId)) {
      multipleSelected.add(componentId);
    }
  }

  void removeComponentFromMultipleSelection(String componentId) {
    multipleSelected.remove(componentId);
  }

  // -- Component operations --

  String duplicateComponent(ComponentData<MyComponentData> componentData) {
    final cd = ComponentData<MyComponentData>(
      type: componentData.type,
      size: componentData.size,
      minSize: componentData.minSize,
      data: MyComponentData.copy(componentData.data!),
      position: componentData.position + const Offset(20, 20),
    );
    return controller.addComponent(cd);
  }

  void removeAll() {
    controller.removeAllComponents();
  }

  void resetView() {
    controller.resetCanvasView();
  }

  void removeSelected() {
    for (final componentId in multipleSelected) {
      controller.removeComponent(componentId);
    }
    multipleSelected = [];
  }

  void duplicateSelected() {
    final duplicated = <String>[];
    for (final componentId in multipleSelected) {
      final newId =
          duplicateComponent(controller.getComponent(componentId));
      duplicated.add(newId);
    }
    hideAllHighlights();
    multipleSelected = [];
    for (final componentId in duplicated) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
      controller.bringToFront(componentId);
    }
  }

  void selectAll() {
    for (final componentId in controller.components.keys) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    }
  }

  // -- Link option helpers --

  void showLinkOption(String linkId, Offset position) {
    selectedLinkId = linkId;
    tapLinkPosition = position;
  }

  void hideLinkOption() {
    selectedLinkId = null;
  }

  // -- Connection helper --

  bool connectComponents(String? sourceId, String? targetId) {
    if (sourceId == null || targetId == null) return false;
    if (sourceId == targetId) return false;
    if (controller.getComponent(sourceId).connections.any(
          (c) =>
              c is OutgoingConnection && c.otherComponentId == targetId,
        )) {
      return false;
    }
    controller.connect(
      sourceComponentId: sourceId,
      targetComponentId: targetId,
      linkStyle: const LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
      data: MyLinkData(),
    );
    return true;
  }

  // -- Component builder --

  Widget buildComponentBody(
      BuildContext context, ComponentData<MyComponentData> componentData) {
    switch (componentData.type) {
      case 'rect':
        return RectBody(componentData: componentData);
      case 'round_rect':
        return RoundRectBody(componentData: componentData);
      case 'oval':
        return OvalBody(componentData: componentData);
      case 'crystal':
        return CrystalBody(componentData: componentData);
      case 'body':
        return RectBody(componentData: componentData);
      case 'rhomboid':
        return RhomboidBody(componentData: componentData);
      case 'bean':
        return BeanBody(componentData: componentData);
      case 'bean_left':
        return BeanLeftBody(componentData: componentData);
      case 'bean_right':
        return BeanRightBody(componentData: componentData);
      case 'document':
        return DocumentBody(componentData: componentData);
      case 'hexagon_horizontal':
        return HexagonHorizontalBody(componentData: componentData);
      case 'hexagon_vertical':
        return HexagonVerticalBody(componentData: componentData);
      case 'bend_left':
        return BendLeftBody(componentData: componentData);
      case 'bend_right':
        return BendRightBody(componentData: componentData);
      case 'no_corner_rect':
        return NoCornerRectBody(componentData: componentData);
      case 'junction':
        return OvalBody(componentData: componentData);
      default:
        return const SizedBox.shrink();
    }
  }

  // -- Component overlay builder (highlight only, non-interactive) --

  Widget buildComponentOverlay(
      BuildContext context, ComponentData<MyComponentData> componentData) {
    if (!(componentData.data?.isHighlightVisible ?? false)) {
      return const SizedBox.shrink();
    }
    final scale = controller.canvasScale;
    final color = isMultipleSelectionOn ? Colors.cyan : Colors.red;
    return IgnorePointer(
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (componentData.size.width + 4) * scale,
          height: (componentData.size.height + 4) * scale,
          color: color,
        ),
      ),
    );
  }

  // -- Foreground builder (clickable buttons at canvas level) --

  List<Widget> buildForeground(BuildContext context) {
    final widgets = <Widget>[];

    for (final componentData in controller.components.values) {
      if (!(componentData.data?.isHighlightVisible ?? false)) continue;

      final isJunction = componentData.type == 'junction';
      final showOptions =
          !isMultipleSelectionOn && !isReadyToConnect && !isJunction;

      if (showOptions) {
        widgets.add(_componentTopOptions(componentData, context));
        widgets.add(_componentBottomOptions(componentData));
        widgets.add(_resizeCorner(componentData));
      }
      if (isJunction && !isReadyToConnect) {
        widgets.add(_junctionOptions(componentData));
      }
    }

    return widgets;
  }

  Widget _componentTopOptions(
      ComponentData<MyComponentData> componentData, BuildContext context) {
    final pos = controller.toCanvasCoordinates(componentData.position);
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
              controller.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.copy,
            tooltip: 'duplicate',
            size: 40,
            onPressed: () {
              final newId = duplicateComponent(componentData);
              controller.bringToFront(newId);
              selectedComponentId = newId;
              hideComponentHighlight(componentData.id);
              highlightComponent(newId);
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.edit,
            tooltip: 'edit',
            size: 40,
            onPressed: () =>
                showEditComponentDialog(context, componentData),
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () =>
                controller.removeComponentLinks(componentData.id),
          ),
        ],
      ),
    );
  }

  Widget _componentBottomOptions(
      ComponentData<MyComponentData> componentData) {
    final scale = controller.canvasScale;
    final pos = controller.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy + componentData.size.height * scale + 8,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => controller.bringToFront(componentData.id),
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => controller.sendToBack(componentData.id),
          ),
          const SizedBox(width: 40),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 40,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }

  Widget _resizeCorner(ComponentData<MyComponentData> componentData) {
    final pos = controller.toCanvasCoordinates(
      componentData.position + componentData.size.bottomRight(Offset.zero),
    );
    return Positioned(
      left: pos.dx - 12,
      top: pos.dy - 12,
      child: GestureDetector(
        onPanUpdate: (details) {
          controller.resizeComponent(
            componentData.id,
            details.delta / controller.canvasScale,
          );
          controller.updateLinks(componentData.id);
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

  Widget _junctionOptions(ComponentData<MyComponentData> componentData) {
    final pos = controller.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              controller.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withValues(alpha: 0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }

  // -- Link widget builder --

  Widget buildLinkWidget(
      BuildContext context, LinkData<MyLinkData> linkData) {
    const double linkLabelSize = 32;
    final linkStartLabelPosition = _labelPosition(
      linkData.linkPoints.first,
      linkData.linkPoints[1],
      linkLabelSize / 2,
      false,
    );
    final linkEndLabelPosition = _labelPosition(
      linkData.linkPoints.last,
      linkData.linkPoints[linkData.linkPoints.length - 2],
      linkLabelSize / 2,
      true,
    );

    return Stack(
      children: [
        _label(
          linkStartLabelPosition,
          linkData.data?.startLabel ?? '',
          linkLabelSize,
        ),
        _label(
          linkEndLabelPosition,
          linkData.data?.endLabel ?? '',
          linkLabelSize,
        ),
        if (selectedLinkId == linkData.id)
          _showLinkOptions(context, linkData),
      ],
    );
  }

  Widget _showLinkOptions(
      BuildContext context, LinkData<MyLinkData> linkData) {
    final nPos = controller.toCanvasCoordinates(tapLinkPosition);
    return Positioned(
      left: nPos.dx,
      top: nPos.dy,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.removeLink(linkData.id),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              width: 32,
              height: 32,
              child: const Center(child: Icon(Icons.close, size: 20)),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => showEditLinkDialog(
              context,
              linkData,
              controller,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              width: 32,
              height: 32,
              child: const Center(child: Icon(Icons.edit, size: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(Offset position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * controller.canvasScale,
      height: size * controller.canvasScale,
      child: GestureDetector(
        onTap: () {},
        onLongPress: () {},
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 10 * controller.canvasScale),
          ),
        ),
      ),
    );
  }

  Offset _labelPosition(
    Offset point1,
    Offset point2,
    double labelSize,
    bool left,
  ) {
    final normalized = VectorUtils.normalizeVector(point2 - point1);
    return controller.toCanvasCoordinates(
      point1 -
          Offset(labelSize, labelSize) +
          normalized * labelSize +
          VectorUtils.getPerpendicularVectorToVector(normalized, clockwise: left) *
              labelSize,
    );
  }

  // -- Background builder --

  List<Widget> buildBackground(BuildContext context) {
    return [
      Visibility(
        visible: isGridVisible,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(
            offset:
                controller.canvasPosition / controller.canvasScale,
            scale: controller.canvasScale,
            lineWidth: (controller.canvasScale < 1.0)
                ? controller.canvasScale
                : 1.0,
            matchParentSize: false,
            lineColor: const Color(0xFF0D47A1),
          ),
        ),
      ),
      DragTarget<ComponentData<MyComponentData>>(
        builder: (_, __, ___) => const SizedBox.shrink(),
        onWillAcceptWithDetails:
            (DragTargetDetails<ComponentData<MyComponentData>> data) =>
                true,
        onAcceptWithDetails:
            (DragTargetDetails<ComponentData<MyComponentData>> details) =>
                _onAcceptWithDetails(details, context),
      ),
    ];
  }

  void _onAcceptWithDetails(
    DragTargetDetails<ComponentData<MyComponentData>> details,
    BuildContext context,
  ) {
    final renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;
    final localOffset = renderObject.globalToLocal(details.offset);
    final componentData = details.data;
    final componentPosition =
        controller.fromCanvasCoordinates(localOffset);
    final componentId = controller.addComponent(
      ComponentData<MyComponentData>(
        position: componentPosition,
        data: MyComponentData.copy(componentData.data!),
        size: componentData.size,
        minSize: componentData.minSize,
        type: componentData.type,
      ),
    );
    controller.bringToFrontWithChildren(componentId);
  }

  // -- Minimap widget --

  final _miniMapTransformController = TransformationController();

  Widget _buildMiniMap() {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final components = controller.componentsSorted;
        if (components.isEmpty) {
          return Container(
            color: const Color(0xFFE0E0E0).withValues(alpha: 0.9),
          );
        }

        return Container(
          color: const Color(0xFFE0E0E0).withValues(alpha: 0.9),
          child: InteractiveViewer(
            transformationController: _miniMapTransformController,
            minScale: 0.5,
            maxScale: 5.0,
            child: CustomPaint(
              size: const Size(320, 240),
              painter: _MiniMapPainter(
                components: components,
                links: controller.links.values.toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // -- Build --

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DiagramEditor<MyComponentData, MyLinkData>(
                    controller: controller,
                    componentBuilder: buildComponentBody,
                    componentOverlayBuilder: buildComponentOverlay,
                    linkWidgetBuilder: buildLinkWidget,
                    backgroundBuilder: buildBackground,
                    foregroundBuilder: buildForeground,

                    // Canvas callbacks
                    onCanvasTap: () {
                      setState(() {
                        multipleSelected = [];
                        if (isReadyToConnect) {
                          isReadyToConnect = false;
                          if (selectedComponentId != null) {
                            controller
                                .updateComponent(selectedComponentId);
                          }
                        } else {
                          selectedComponentId = null;
                          hideAllHighlights();
                        }
                      });
                    },

                    // Component callbacks
                    onComponentTap: (componentId) {
                      setState(() {
                        if (isMultipleSelectionOn) {
                          if (multipleSelected.contains(componentId)) {
                            removeComponentFromMultipleSelection(
                                componentId);
                            hideComponentHighlight(componentId);
                          } else {
                            addComponentToMultipleSelection(componentId);
                            highlightComponent(componentId);
                          }
                        } else {
                          hideAllHighlights();
                          if (isReadyToConnect) {
                            isReadyToConnect = false;
                            final connected = connectComponents(
                                selectedComponentId, componentId);
                            if (connected) {
                              selectedComponentId = null;
                            } else {
                              selectedComponentId = componentId;
                              highlightComponent(componentId);
                            }
                          } else {
                            selectedComponentId = componentId;
                            highlightComponent(componentId);
                          }
                        }
                      });
                    },
                    onComponentScaleStart: (componentId, details) {
                      lastFocalPoint = details.localFocalPoint;
                      hideLinkOption();
                      if (isMultipleSelectionOn) {
                        addComponentToMultipleSelection(componentId);
                        highlightComponent(componentId);
                      }
                    },
                    onComponentScaleUpdate: (componentId, details) {
                      final positionDelta =
                          details.localFocalPoint - lastFocalPoint;
                      if (isMultipleSelectionOn) {
                        for (final id in multipleSelected) {
                          final cmp = controller.getComponent(id);
                          controller.moveComponent(id, positionDelta);
                          for (final connection in cmp.connections) {
                            if (connection is OutgoingConnection &&
                                multipleSelected.contains(
                                    connection.otherComponentId)) {
                              controller.moveAllLinkJoints(
                                  connection.linkId, positionDelta);
                            }
                          }
                        }
                      } else {
                        controller.moveComponent(
                            componentId, positionDelta);
                      }
                      lastFocalPoint = details.localFocalPoint;
                      controller.updateCanvas();
                    },

                    // Link callbacks
                    onLinkTapUp: (linkId, details) {
                      setState(() {
                        hideLinkOption();
                        controller.hideAllLinkJoints();
                        controller.showLinkJoints(linkId);
                        showLinkOption(
                          linkId,
                          controller.fromCanvasCoordinates(
                              details.localPosition),
                        );
                      });
                    },
                    onLinkScaleStart: (linkId, details) {
                      hideLinkOption();
                      controller.hideAllLinkJoints();
                      controller.showLinkJoints(linkId);
                      segmentIndex = controller.determineLinkSegmentIndex(
                        linkId,
                        details.localFocalPoint,
                      );
                      if (segmentIndex != null) {
                        controller.insertLinkJoint(
                          linkId,
                          details.localFocalPoint,
                          segmentIndex!,
                        );
                        controller.updateLinkEndpoints(linkId);
                      }
                    },
                    onLinkScaleUpdate: (linkId, details) {
                      if (segmentIndex != null) {
                        controller.setLinkJointPosition(
                          linkId,
                          details.localFocalPoint,
                          segmentIndex!,
                        );
                        controller.updateLinkEndpoints(linkId);
                      }
                    },
                    onLinkLongPressStart: (linkId, details) {
                      hideLinkOption();
                      controller.hideAllLinkJoints();
                      controller.showLinkJoints(linkId);
                      segmentIndex = controller.determineLinkSegmentIndex(
                        linkId,
                        details.localPosition,
                      );
                      if (segmentIndex != null) {
                        controller.insertLinkJoint(
                          linkId,
                          details.localPosition,
                          segmentIndex!,
                        );
                        controller.updateLinkEndpoints(linkId);
                      }
                    },
                    onLinkLongPressMoveUpdate: (linkId, details) {
                      if (segmentIndex != null) {
                        controller.setLinkJointPosition(
                          linkId,
                          details.localPosition,
                          segmentIndex!,
                        );
                        controller.updateLinkEndpoints(linkId);
                      }
                    },

                    // Link joint callbacks
                    onLinkJointLongPress: (jointIndex, linkId) {
                      controller.removeLinkJoint(linkId, jointIndex);
                      controller.updateLinkEndpoints(linkId);
                      hideLinkOption();
                    },
                    onLinkJointScaleUpdate:
                        (jointIndex, linkId, details) {
                      controller.setLinkJointPosition(
                        linkId,
                        details.localFocalPoint,
                        jointIndex,
                      );
                      controller.updateLinkEndpoints(linkId);
                      hideLinkOption();
                    },

                    // Disable default link/joint control since we handle it
                    enableDefaultLinkControl: false,
                    enableDefaultJointControl: false,
                  ),
                ),
              ),

              // Minimap
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isMiniMapVisible,
                      child: SizedBox(
                        width: 320,
                        height: 240,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: ClipRect(child: _buildMiniMap()),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMiniMapVisible = !isMiniMapVisible;
                        });
                      },
                      child: Container(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(isMiniMapVisible
                              ? 'hide minimap'
                              : 'show minimap'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom toolbar
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OptionIcon(
                        color: Colors.grey.withValues(alpha: 0.7),
                        iconData: isOptionsVisible
                            ? Icons.menu_open
                            : Icons.menu,
                        shape: BoxShape.rectangle,
                        onPressed: () {
                          setState(() {
                            isOptionsVisible = !isOptionsVisible;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: isOptionsVisible,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            OptionIcon(
                              tooltip: 'reset view',
                              color:
                                  Colors.grey.withValues(alpha: 0.7),
                              iconData: Icons.replay,
                              onPressed: resetView,
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'delete all',
                              color:
                                  Colors.grey.withValues(alpha: 0.7),
                              iconData: Icons.delete_forever,
                              onPressed: removeAll,
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: isGridVisible
                                  ? 'hide grid'
                                  : 'show grid',
                              color:
                                  Colors.grey.withValues(alpha: 0.7),
                              iconData: isGridVisible
                                  ? Icons.grid_off
                                  : Icons.grid_on,
                              onPressed: () {
                                setState(() {
                                  isGridVisible = !isGridVisible;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: isMultipleSelectionOn,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: [
                                      OptionIcon(
                                        tooltip: 'select all',
                                        color: Colors.grey
                                            .withValues(alpha: 0.7),
                                        iconData: Icons.all_inclusive,
                                        onPressed: selectAll,
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'duplicate selected',
                                        color: Colors.grey
                                            .withValues(alpha: 0.7),
                                        iconData: Icons.copy,
                                        onPressed: duplicateSelected,
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'remove selected',
                                        color: Colors.grey
                                            .withValues(alpha: 0.7),
                                        iconData: Icons.delete,
                                        onPressed: removeSelected,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OptionIcon(
                                  tooltip: isMultipleSelectionOn
                                      ? 'cancel multiselection'
                                      : 'enable multiselection',
                                  color: Colors.grey
                                      .withValues(alpha: 0.7),
                                  iconData: isMultipleSelectionOn
                                      ? Icons.group_work
                                      : Icons.group_work_outlined,
                                  onPressed: () {
                                    setState(() {
                                      if (isMultipleSelectionOn) {
                                        turnOffMultipleSelection();
                                      } else {
                                        turnOnMultipleSelection();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Left menu
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Visibility(
                      visible: isMenuVisible,
                      child: Container(
                        color: Colors.grey.withValues(alpha: 0.7),
                        width: 120,
                        height: 320,
                        child: DraggableMenu(
                          bodies: bodies,
                          componentBuilder: buildComponentBody,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMenuVisible = !isMenuVisible;
                          });
                        },
                        child: Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(isMenuVisible
                                ? 'hide menu'
                                : 'show menu'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Back button
              Positioned(
                top: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.blue),
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

// Minimap painter that renders real component shapes
class _MiniMapPainter extends CustomPainter {
  final List<ComponentData<MyComponentData>> components;
  final List<LinkData<MyLinkData>> links;

  _MiniMapPainter({required this.components, required this.links});

  @override
  void paint(Canvas canvas, Size size) {
    if (components.isEmpty) return;

    // Calculate bounds of all components
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
    for (final c in components) {
      if (c.position.dx < minX) minX = c.position.dx;
      if (c.position.dy < minY) minY = c.position.dy;
      if (c.position.dx + c.size.width > maxX) {
        maxX = c.position.dx + c.size.width;
      }
      if (c.position.dy + c.size.height > maxY) {
        maxY = c.position.dy + c.size.height;
      }
    }

    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;
    if (contentWidth <= 0 || contentHeight <= 0) return;

    // Add padding
    const padding = 20.0;
    final scaleX = (size.width - padding * 2) / contentWidth;
    final scaleY = (size.height - padding * 2) / contentHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final offsetX =
        padding + (size.width - padding * 2 - contentWidth * scale) / 2;
    final offsetY =
        padding + (size.height - padding * 2 - contentHeight * scale) / 2;

    // Draw links
    final linkPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final link in links) {
      final points = link.linkPoints;
      if (points.length >= 2) {
        for (int i = 0; i < points.length - 1; i++) {
          canvas.drawLine(
            Offset(
              (points[i].dx - minX) * scale + offsetX,
              (points[i].dy - minY) * scale + offsetY,
            ),
            Offset(
              (points[i + 1].dx - minX) * scale + offsetX,
              (points[i + 1].dy - minY) * scale + offsetY,
            ),
            linkPaint,
          );
        }
      }
    }

    // Draw components with real shapes
    for (final c in components) {
      final x = (c.position.dx - minX) * scale + offsetX;
      final y = (c.position.dy - minY) * scale + offsetY;
      final w = c.size.width * scale;
      final h = c.size.height * scale;

      canvas.save();
      canvas.translate(x, y);

      final path = _componentPath(c.type ?? 'rect', Size(w, h));

      final fillPaint = Paint()
        ..color = c.data?.color ?? Colors.grey
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      final borderPaint = Paint()
        ..color = c.data?.borderColor ?? Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawPath(path, borderPaint);

      canvas.restore();
    }
  }

  static Path _componentPath(String type, Size s) {
    final w = s.width;
    final h = s.height;
    final path = Path();

    switch (type) {
      case 'oval':
      case 'junction':
        path.addOval(Rect.fromLTWH(0, 0, w, h));

      case 'round_rect':
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          const Radius.circular(16),
        ));

      case 'crystal':
        path.moveTo(0, h / 2);
        path.lineTo(w / 2, 0);
        path.lineTo(w, h / 2);
        path.lineTo(w / 2, h);
        path.close();

      case 'rhomboid':
        path.moveTo(w / 6, 0);
        path.lineTo(w, 0);
        path.lineTo(5 * w / 6, h);
        path.lineTo(0, h);
        path.close();

      case 'bean':
        path.moveTo(w / 5, 0);
        path.lineTo(4 * w / 5, 0);
        path.quadraticBezierTo(w, h / 6, w, h / 2);
        path.quadraticBezierTo(w, 5 * h / 6, 4 * w / 5, h);
        path.lineTo(w / 5, h);
        path.quadraticBezierTo(0, 5 * h / 6, 0, h / 2);
        path.quadraticBezierTo(0, h / 6, w / 5, 0);
        path.close();

      case 'bean_left':
        path.moveTo(w / 5, 0);
        path.lineTo(w, 0);
        path.lineTo(w, h);
        path.lineTo(w / 5, h);
        path.quadraticBezierTo(0, 5 * h / 6, 0, h / 2);
        path.quadraticBezierTo(0, h / 6, w / 5, 0);
        path.close();

      case 'bean_right':
        path.moveTo(0, 0);
        path.lineTo(4 * w / 5, 0);
        path.quadraticBezierTo(w, h / 6, w, h / 2);
        path.quadraticBezierTo(w, 5 * h / 6, 4 * w / 5, h);
        path.lineTo(0, h);
        path.close();

      case 'document':
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(w, 9 * h / 10);
        path.quadraticBezierTo(3 * w / 4, 7 * h / 10, w / 2, 9 * h / 10);
        path.quadraticBezierTo(w / 4, 11 * h / 10, 0, 9 * h / 10);
        path.close();

      case 'hexagon_horizontal':
        path.moveTo(w / 4, 0);
        path.lineTo(3 * w / 4, 0);
        path.lineTo(w, h / 2);
        path.lineTo(3 * w / 4, h);
        path.lineTo(w / 4, h);
        path.lineTo(0, h / 2);
        path.close();

      case 'hexagon_vertical':
        path.moveTo(w / 2, 0);
        path.lineTo(w, h / 4);
        path.lineTo(w, 3 * h / 4);
        path.lineTo(w / 2, h);
        path.lineTo(0, 3 * h / 4);
        path.lineTo(0, h / 4);
        path.close();

      case 'bend_left':
        path.moveTo(w / 10, 0);
        path.lineTo(w, 0);
        path.quadraticBezierTo(9 * w / 10, h / 5, 9 * w / 10, h / 2);
        path.quadraticBezierTo(9 * w / 10, 4 * h / 5, w, h);
        path.lineTo(w / 10, h);
        path.quadraticBezierTo(0, 4 * h / 5, 0, h / 2);
        path.quadraticBezierTo(0, h / 5, w / 10, 0);
        path.close();

      case 'bend_right':
        path.moveTo(0, 0);
        path.lineTo(9 * w / 10, 0);
        path.quadraticBezierTo(w, h / 5, w, h / 2);
        path.quadraticBezierTo(w, 4 * h / 5, 9 * w / 10, h);
        path.lineTo(0, h);
        path.quadraticBezierTo(w / 10, 4 * h / 5, w / 10, h / 2);
        path.quadraticBezierTo(w / 10, h / 5, 0, 0);
        path.close();

      case 'no_corner_rect':
        path.moveTo(w / 8, 0);
        path.lineTo(7 * w / 8, 0);
        path.lineTo(w, h / 8);
        path.lineTo(w, 7 * h / 8);
        path.lineTo(7 * w / 8, h);
        path.lineTo(w / 8, h);
        path.lineTo(0, 7 * h / 8);
        path.lineTo(0, h / 8);
        path.close();

      default: // 'rect', 'body', etc.
        path.addRect(Rect.fromLTWH(0, 0, w, h));
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter oldDelegate) => true;
}
