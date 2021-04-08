import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/data/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/policy/my_policy_set.dart';
import 'package:flutter/material.dart';

class DraggableMenu extends StatelessWidget {
  final MyPolicySet myPolicySet;

  const DraggableMenu({
    Key key,
    this.myPolicySet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...myPolicySet.bodies
            .map(
              (componentType) => Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: DraggableComponent(
                    myPolicySet: myPolicySet,
                    componentData: ComponentData(
                      size: Size(140, 80),
                      minSize: Size(80, 64),
                      data: MyComponentData(
                        color: Colors.white,
                        borderColor: Colors.black,
                        borderWidth: 2.0,
                        // text: 'custom text',
                      ),
                      type: componentType,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

class DraggableComponent extends StatelessWidget {
  final MyPolicySet myPolicySet;
  final ComponentData componentData;

  const DraggableComponent({
    Key key,
    this.myPolicySet,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: myPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: componentData.size.width,
          height: componentData.size.height,
          child: myPolicySet.showComponentBody(componentData),
        ),
      ),
      child: myPolicySet.showComponentBody(componentData),
    );
  }
}
