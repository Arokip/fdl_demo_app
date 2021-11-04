import 'package:diagram_editor/diagram_editor.dart';
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
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget? showComponentBody(ComponentData componentData) {
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
        return null;
    }
  }
}
