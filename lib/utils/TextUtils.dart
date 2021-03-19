import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:x3/utils/textConstants.dart';

class PText extends StatelessWidget {
  final String textKey;
  final TextStyle theme;

  const PText({Key key, @required this.textKey, this.theme = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
      stream: Hive.box('settings').watch(key: "language"),
      builder: (BuildContext context, AsyncSnapshot<BoxEvent> snapshot) {
        return Text(
          TextConstants.getInstance().get(textKey),
          style: theme,
        );
      },
    );
  }
}
