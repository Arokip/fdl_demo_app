import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/policy/default_canvas_policy.dart';
import 'package:diagram_editor_apps/policy/default_canvas_widgets_policy.dart';
import 'package:diagram_editor_apps/policy/default_component_design_policy.dart';
import 'package:diagram_editor_apps/policy/default_component_policy.dart';
import 'package:diagram_editor_apps/policy/default_custom_policy.dart';
import 'package:diagram_editor_apps/policy/default_init_policy.dart';

class MyPolicySet extends PolicySet
    with
        DefaultInitPolicy,
        DefaultCanvasPolicy,
        DefaultComponentPolicy,
        DefaultComponentDesignPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy,
        LinkBorderAttachmentPolicy,
        DefaultCanvasWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        CustomStatePolicy,
        CustomBehaviourPolicy {}
