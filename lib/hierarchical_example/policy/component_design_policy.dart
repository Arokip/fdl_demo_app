import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/hierarchical_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy, CustomPolicy {
  @override
  Widget? showComponentBody(ComponentData componentData) {
    final text = Text(
      'id: ${componentData.id.substring(0, 4)}',
      style: TextStyle(fontSize: 10),
    );
    return Container(
      decoration: BoxDecoration(
        color: componentData.data.color,
        border: Border.all(
            width: 2,
            color: componentData.data.isHighlightVisible
                ? Colors.pink
                : Colors.black),
      ),
      child: Center(
        child: isReadyToAddParent
            ? Text('tap on parent', style: TextStyle(fontSize: 10))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text,
                  Text(
                    componentData.parentId == null
                        ? 'no parent'
                        : 'parent: ${componentData.parentId?.substring(0, 4)}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
      ),
    );
  }
}
