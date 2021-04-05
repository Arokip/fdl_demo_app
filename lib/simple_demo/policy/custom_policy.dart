import 'package:diagram_editor/diagram_editor.dart';

mixin CustomStatePolicy implements PolicySet {
  List<String> bodies = ['rect', 'oval', 'crystal'];

  int custom = 0;
  String selectedComponentId;

  List<String> multipleSelected = [];

  hideAllHighlights() {
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.hideAllLinkDeleteIcons();
    canvasReader.model.getAllComponents().values.forEach((component) {
      if (component.data.isHighlightVisible) {
        component.data.hideHighlight();
        canvasWriter.model.updateComponent(component.id);
      }
    });
  }

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  removeAll() {
    print('custom butt: ${custom++}');
    canvasWriter.model.removeAllComponents();
  }

  resetView() {
    print('custom butt: ${custom++}');
    canvasWriter.state.resetCanvasView();
  }
}
