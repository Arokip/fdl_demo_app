import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo/widget/port_body_widget.dart';
import 'package:diagram_editor_apps/port_demo/widget/rect_widget_body.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    switch (componentData.type) {
      case 'port':
        return PortBodyWidget(componentData: componentData);
        break;
      case 'rect':
        return RectWidgetBody(componentData: componentData);
        break;
      default:
        return null;
        break;
    }
  }
}
