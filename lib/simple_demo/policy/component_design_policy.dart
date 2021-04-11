import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/bean_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/bean_left_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/bean_right_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/bend_left_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/bend_right_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/crystal_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/document_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/hexagon_horizontal_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/hexagon_vertical_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/no_corner_rect_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/oval_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/rect_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/rhomboid_component.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/round_rect_component.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    switch (componentData.type) {
      case 'rect':
        return RectBody(componentData: componentData);
        break;
      case 'round_rect':
        return RoundRectBody(componentData: componentData);
        break;
      case 'oval':
        return OvalBody(componentData: componentData);
        break;
      case 'crystal':
        return CrystalBody(componentData: componentData);
        break;
      case 'body':
        return RectBody(componentData: componentData);
        break;
      case 'rhomboid':
        return RhomboidBody(componentData: componentData);
        break;
      case 'bean':
        return BeanBody(componentData: componentData);
        break;
      case 'bean_left':
        return BeanLeftBody(componentData: componentData);
        break;
      case 'bean_right':
        return BeanRightBody(componentData: componentData);
        break;
      case 'document':
        return DocumentBody(componentData: componentData);
        break;
      case 'hexagon_horizontal':
        return HexagonHorizontalBody(componentData: componentData);
        break;
      case 'hexagon_vertical':
        return HexagonVerticalBody(componentData: componentData);
        break;
      case 'bend_left':
        return BendLeftBody(componentData: componentData);
        break;
      case 'bend_right':
        return BendRightBody(componentData: componentData);
        break;
      case 'no_corner_rect':
        return NoCornerRectBody(componentData: componentData);
        break;
      case 'junction':
        return OvalBody(componentData: componentData);
        break;
      default:
        return null;
        break;
    }
  }
}
