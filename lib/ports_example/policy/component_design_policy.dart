import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/ports_example/widget/port_component.dart';
import 'package:diagram_editor_apps/ports_example/widget/rect_component.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    switch (componentData.type) {
      case 'component':
        return RectComponent(componentData: componentData);
        break;
      case 'port':
        return PortComponent(componentData: componentData);
        break;
      default:
        return SizedBox.shrink();
        break;
    }
  }
}
