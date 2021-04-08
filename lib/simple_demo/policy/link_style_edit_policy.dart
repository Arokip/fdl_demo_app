import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/main.dart';
import 'package:diagram_editor_apps/simple_demo/dialog/edit_link_dialog.dart';

mixin LinkStyleEditPolicy implements LinkPolicy {
  @override
  onLinkLongPress(String linkId) {
    print('link style edit policy');

    showEditLinkDialog(
      navigatorKey.currentContext,
      canvasReader.model.getLink(linkId),
    );
  }
}
