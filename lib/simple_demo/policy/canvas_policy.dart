import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  onCanvasTap() {
    selectedComponentId = null;

    multipleSelected = [];

    hideAllHighlights();
  }
}
