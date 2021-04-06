import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/crystal_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/oval_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/rect_component.dart';

import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    switch (componentData.type) {
      case 'rect':
        return RectWidgetBody(componentData: componentData);
        break;
      case 'oval':
        return OvalWidgetBody(componentData: componentData);
        break;
      case 'crystal':
        return CrystalWidgetBody(componentData: componentData);
        break;
      case 'body':
        return RectWidgetBody(componentData: componentData);
        break;
      default:
        return null;
        break;
    }
  }
}
