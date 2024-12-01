import 'dart:async';

import 'package:flutter/material.dart';

Future<String> showCustomDialog(
    String title, String message, BuildContext context, bool isError) async {
  Completer<String> completer = Completer<String>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: isError == true ? Colors.red : Colors.green,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 118, 121, 118),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              completer.complete("done");
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
        backgroundColor: isError ? Colors.white : Colors.white,
      );
    },
  );

  return completer.future;
}
