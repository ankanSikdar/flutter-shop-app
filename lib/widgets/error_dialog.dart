import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String error;

  ErrorAlertDialog({this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'An ERROR Occured!',
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Colors.black,
            ),
      ),
      content: Text(error),
      actions: [
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
