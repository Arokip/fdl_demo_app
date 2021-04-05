import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/port_demo/policy/canvas_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/canvas_widgets_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/component_design_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/component_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/component_widgets_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/custom_policy.dart';
import 'package:diagram_editor_apps/port_demo/policy/init_policy.dart';
import 'package:diagram_editor_apps/simple_demo/policy/link_attachment_policy.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        CustomStatePolicy,
        CustomBehaviourPolicy {}
