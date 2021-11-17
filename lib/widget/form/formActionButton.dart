import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget formActionButton(
    BuildContext context,
    Function elevatedButtonFunction,
    String elevatedButtonText,
    String questionText,
    String textButtonText,
    Function textButtonFunction) {
  return Column(
    children: [
      Center(
        child: ElevatedButton(
          onPressed: () => elevatedButtonFunction(),
          child: Text(elevatedButtonText),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(200.0, 30.0),
            primary: Colors.amber,
          ),
        ),
      ),
      Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(questionText),
              TextButton(
                  onPressed: () => textButtonFunction(),
                  child: Text(
                    textButtonText,
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  )),
            ],
          )),
    ],
  );
}
