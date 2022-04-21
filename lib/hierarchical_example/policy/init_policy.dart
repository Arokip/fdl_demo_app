import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/component_data.dart';
import 'package:flutter/material.dart';

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.grey[300]!);

    var cd1 = getSmallComponentData(Offset(220, 100));
    var cd2 = getSmallComponentData(Offset(220, 180));
    var cd3 = getSmallComponentData(Offset(400, 100));
    var cd4 = getSmallComponentData(Offset(400, 180));

    var cd5 = getBigComponentData(Offset(80, 80));
    var cd6 = getBigComponentData(Offset(380, 80));

    canvasWriter.model.addComponent(cd1);
    canvasWriter.model.addComponent(cd2);
    canvasWriter.model.addComponent(cd3);
    canvasWriter.model.addComponent(cd4);
    canvasWriter.model.addComponent(cd5);
    canvasWriter.model.addComponent(cd6);

    canvasWriter.model.moveComponentToTheFront(cd5.id);
    canvasWriter.model.moveComponentToTheFront(cd6.id);

    canvasWriter.model.moveComponentToTheFront(cd1.id);
    canvasWriter.model.moveComponentToTheFront(cd2.id);
    canvasWriter.model.moveComponentToTheFront(cd3.id);
    canvasWriter.model.moveComponentToTheFront(cd4.id);

    canvasWriter.model.setComponentParent(cd1.id, cd5.id);
    canvasWriter.model.setComponentParent(cd2.id, cd5.id);

    canvasWriter.model.setComponentParent(cd3.id, cd6.id);
    canvasWriter.model.setComponentParent(cd4.id, cd6.id);

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: cd1.id,
      targetComponentId: cd3.id,
      linkStyle: LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
    canvasWriter.model.connectTwoComponents(
      sourceComponentId: cd4.id,
      targetComponentId: cd2.id,
      linkStyle: LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
  }

  ComponentData getSmallComponentData(Offset position) {
    return ComponentData(
      size: Size(80, 64),
      minSize: Size(72, 48),
      position: position,
      data: MyComponentData(),
    );
  }

  ComponentData getBigComponentData(Offset position) {
    return ComponentData(
      size: Size(240, 180),
      minSize: Size(72, 48),
      position: position,
      data: MyComponentData(),
    );
  }
}
