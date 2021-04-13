import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class RainbowItem extends StatelessWidget {
  final Color color;
  final double width;

  const RainbowItem({Key key, this.color, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${color.toString()}',
      child: Container(width: width, color: color),
    );
  }
}

class ComplexRainbowComponent extends StatelessWidget {
  final ComponentData componentData;

  const ComplexRainbowComponent({
    Key key,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: componentData.data.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 4,
          color: componentData.data.isHighlightVisible
              ? Colors.pink
              : Colors.black,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 8),
          Center(
            child: Text(
              'title text',
              style: TextStyle(fontSize: 32),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 8,
            indent: 24,
            endIndent: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.emoji_emotions, color: Colors.grey, size: 64),
              Icon(Icons.gesture, color: Colors.amber, size: 64),
              SizedBox(width: 8),
              Text(
                'some text',
                style: TextStyle(fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'This is a bit more complex component... try to scroll the rainbow below.',
            style: TextStyle(fontSize: 11),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    RainbowItem(width: 80, color: Colors.red),
                    RainbowItem(width: 80, color: Colors.orange),
                    RainbowItem(width: 80, color: Colors.amber),
                    RainbowItem(width: 80, color: Colors.yellow),
                    RainbowItem(width: 80, color: Colors.lime),
                    RainbowItem(width: 80, color: Colors.green),
                    RainbowItem(width: 80, color: Colors.cyan),
                    RainbowItem(width: 80, color: Colors.blue),
                    RainbowItem(width: 80, color: Colors.indigo),
                    RainbowItem(width: 80, color: Colors.purple),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
