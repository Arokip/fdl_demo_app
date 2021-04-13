import 'package:diagram_editor/diagram_editor.dart';

mixin CustomPolicy implements PolicySet {
  String selectedComponentId;

  bool isReadyToAddParent = false;

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(String componentId) {
    if (selectedComponentId != null) {
      canvasReader.model.getComponent(componentId).data.hideHighlight();
      canvasReader.model.getComponent(componentId).updateComponent();
    }
  }

  deleteAllComponents() {
    selectedComponentId = null;
    canvasWriter.model.removeAllComponents();
  }
}
