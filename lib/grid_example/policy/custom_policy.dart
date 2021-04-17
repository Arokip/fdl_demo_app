import 'package:diagram_editor/diagram_editor.dart';

mixin CustomPolicy implements PolicySet {
  double gridGap = 80;

// if the component is this pixels close to grid line than it snaps to it.
  double snapSize = 20;

  bool isSnappingEnabled = true;

  switchIsSnappingEnabled() {
    isSnappingEnabled = !isSnappingEnabled;
  }

  deleteAllComponents() {
    canvasWriter.model.removeAllComponents();
  }
}
