import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/utils/textConstants.dart';

class PText extends StatelessWidget {
  final String textKey;
  final TextStyle theme;

  const PText({Key key, @required this.textKey, this.theme = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<String>>(
      future: Repo.getInstance().getLanguage(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return StreamBuilder<String>(
          stream: snapshot.data,
          initialData: "en",
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return FutureBuilder(
              future: TextConstants.getInstance().get(textKey, snapshot.data),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Text(
                  snapshot.data == null ? "Null" : snapshot.data,
                  style: theme,
                );
              },
            );
          },
        );
      },
    );
  }
}
