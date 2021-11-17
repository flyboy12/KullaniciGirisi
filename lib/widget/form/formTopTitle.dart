import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget formTopTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0, top: 20, bottom: 10),
    child: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(color: Colors.black87),
    ),
  );
}
