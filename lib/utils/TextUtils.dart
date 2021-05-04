import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/Repository/Sources/LocalSource/localSource.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/utils/textConstants.dart';

class PText extends StatelessWidget {
  final String textKey;
  final TextStyle theme;

  const PText({Key key, @required this.textKey, this.theme = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TextConfiguration>(
      stream: Repo.getInstance().getTextConfiguration(),
      initialData: new TextConfiguration("eng", 0),
      builder: (BuildContext context,
          AsyncSnapshot<TextConfiguration> languageSnapshot) {
        if (languageSnapshot.connectionState == ConnectionState.active)
          return FutureBuilder(
            future: TextConstants.getInstance()
                .get(textKey, languageSnapshot.data.language),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Text(
                snapshot.data == null ? "No value found" : snapshot.data,
                style: theme,
              );
            },
          );
        else {
          return Text(languageSnapshot.connectionState.toString());
        }
      },
    );
  }
}
