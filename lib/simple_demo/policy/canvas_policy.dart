import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/policy/custom_policy.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect) {
      isReadyToConnect = false;
      canvasWriter.model.updateComponent(selectedComponentId);
    } else {
      selectedComponentId = null;
      hideAllHighlights();
    }
  }
}
