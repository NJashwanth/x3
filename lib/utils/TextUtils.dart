import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x3/Repository/Sources/LocalSource/localSource.dart';
import 'package:x3/Repository/repo.dart';
import 'package:x3/utils/textConstants.dart';

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
                style: getTextStyle(languageSnapshot.data.incrementer),
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

  TextStyle getTextStyle(int incrementer) {
    switch (textType) {
      case TextType.appBar:
        return appBarTextStyle(incrementer);
        break;
      case TextType.body1:
        return body1TextStyle(incrementer);
        break;
      case TextType.body2:
        return body2TextStyle(incrementer);
        break;
      case TextType.title:
        return titleTextStyle(incrementer);
        break;
      case TextType.redButtonText:
        return redButtonTextStyle(incrementer);
        break;
      case TextType.whiteButtonText:
        return whiteButtonTextStyle(incrementer);
        break;
      default:
        return body2TextStyle(incrementer);
        break;
    }
  }
}

enum TextType { appBar, body1, body2, title, redButtonText, whiteButtonText }

const String fontFamily = 'Roboto';
const double largeTextSize = 26.0;
const double mediumtTextSize = 20.0;
const double smallTextSize = 16.0;

TextStyle appBarTextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: mediumtTextSize + incrementer,
    color: Colors.white,
  );
}

TextStyle titleTextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: largeTextSize + incrementer,
    color: Colors.black,
  );
}

TextStyle body1TextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: mediumtTextSize + incrementer,
    color: Colors.black,
  );
}

TextStyle body2TextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: smallTextSize + incrementer,
    color: Colors.black,
  );
}

TextStyle redButtonTextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: smallTextSize + incrementer,
    color: Colors.red,
  );
}

TextStyle whiteButtonTextStyle(int incrementer) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: smallTextSize + incrementer,
    color: Colors.white,
  );
}
