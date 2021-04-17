import 'package:diagram_editor_apps/grid_example/policy/policy_set.dart';
import 'package:flutter/material.dart';

class SpanSwitch extends StatefulWidget {
  final MyPolicySet policySet;

  const SpanSwitch({Key key, this.policySet}) : super(key: key);

  @override
  _SpanSwitchState createState() => _SpanSwitchState();
}

class _SpanSwitchState extends State<SpanSwitch> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 100,
      child: GestureDetector(
        onTap: () {
          widget.policySet.switchIsSnappingEnabled();
          setState(() {});
        },
        child: Container(
          width: 200,
          height: 32,
          color: Colors.amber,
          child: Center(
              child: Text(widget.policySet.isSnappingEnabled
                  ? 'grid snapping ENABLED'
                  : 'grid snapping DISABLED')),
        ),
      ),
    );
  }
}
