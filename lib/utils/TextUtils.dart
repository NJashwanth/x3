import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/Repository/Sources/LocalSource/localSource.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/utils/textConstants.dart';
import 'package:x3/utils/textStyles.dart';

class PText extends StatelessWidget {
  final String textKey;
  final TextType textType;

  const PText({Key key, @required this.textKey, @required this.textType})
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
                style: getTextStyle(),
                softWrap: true,
              );
            },
          );
        else {
          return Text(
            languageSnapshot.connectionState.toString(),
            softWrap: true,
          );
        }
      },
    );
  }

  TextStyle getTextStyle() {
    switch (textType) {
      case TextType.appBar:
        return appBarTextStyle;
        break;
      case TextType.body1:
        return body1TextStyle;
        break;
      case TextType.body2:
        return body2TextStyle;
        break;
      case TextType.title:
        return titleTextStyle;
        break;
      case TextType.redButtonText:
        return redButtonTextStyle;
        break;
      case TextType.whiteButtonText:
        return whiteButtonTextStyle;
        break;
      default:
        return body2TextStyle;
        break;
    }
  }
}

enum TextType { appBar, body1, body2, title, redButtonText, whiteButtonText }
