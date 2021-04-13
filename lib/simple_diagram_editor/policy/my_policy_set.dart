import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/canvas_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/canvas_widgets_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/component_design_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/component_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/component_widgets_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/custom_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/init_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/link_attachment_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/link_widgets_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/my_link_control_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/my_link_joint_control_policy.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        CustomStatePolicy,
        CustomBehaviourPolicy {}
