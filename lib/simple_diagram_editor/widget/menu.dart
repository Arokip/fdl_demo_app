import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:flutter/material.dart';

class DraggableMenu extends StatelessWidget {
  final List<String> bodies;
  final Widget Function(BuildContext, ComponentData<MyComponentData>)
      componentBuilder;

  const DraggableMenu({
    super.key,
    required this.bodies,
    required this.componentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...bodies.map(
          (componentType) {
            final componentData = _getComponentData(componentType);
            return Padding(
              padding: const EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth < componentData.size.width
                        ? componentData.size.width *
                            (constraints.maxWidth /
                                componentData.size.width)
                        : componentData.size.width,
                    height: constraints.maxWidth < componentData.size.width
                        ? componentData.size.height *
                            (constraints.maxWidth /
                                componentData.size.width)
                        : componentData.size.height,
                    child: Align(
                      child: AspectRatio(
                        aspectRatio: componentData.size.aspectRatio,
                        child: Tooltip(
                          message: componentData.type ?? '',
                          child: DraggableComponent(
                            componentData: componentData,
                            componentBuilder: componentBuilder,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  ComponentData<MyComponentData> _getComponentData(String componentType) {
    switch (componentType) {
      case 'junction':
        return ComponentData<MyComponentData>(
          size: const Size(16, 16),
          minSize: const Size(4, 4),
          data: MyComponentData(
            color: Colors.black,
            borderWidth: 0.0,
          ),
          type: componentType,
        );
      default:
        return ComponentData<MyComponentData>(
          size: const Size(120, 72),
          minSize: const Size(80, 64),
          data: MyComponentData(
            color: Colors.white,
            borderColor: Colors.black,
            borderWidth: 2.0,
          ),
          type: componentType,
        );
    }
  }
}

class DraggableComponent extends StatelessWidget {
  final ComponentData<MyComponentData> componentData;
  final Widget Function(BuildContext, ComponentData<MyComponentData>)
      componentBuilder;

  const DraggableComponent({
    super.key,
    required this.componentData,
    required this.componentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData<MyComponentData>>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: componentBuilder(context, componentData),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
          child: componentBuilder(context, componentData),
        ),
      ),
      child: componentBuilder(context, componentData),
    );
  }
}
