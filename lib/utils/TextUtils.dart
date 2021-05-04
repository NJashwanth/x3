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
      builder: (BuildContext context,
          AsyncSnapshot<dynamic> languageStreamSnapshot) {
        return StreamBuilder<dynamic>(
          stream: languageStreamSnapshot.data,
          initialData: "eng",
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> languageSnapshot) {
            if (languageSnapshot.connectionState == ConnectionState.active)
              return FutureBuilder(
                future: TextConstants.getInstance()
                    .get(textKey, languageSnapshot.data),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
      },
    );
  }
}
