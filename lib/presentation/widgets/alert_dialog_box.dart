import 'package:flutter/material.dart';

class AlertDialogBox extends StatelessWidget {
  final String title;
  final String content;
  final String text;
  final void Function()? onPressed;

  const AlertDialogBox({
    super.key,
    required this.title,
    required this.content,
    required this.text,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        // cancel button
        TextButton(
          onPressed:(){
            Navigator.of(context).pop();
          },
          child:  const Text("Cancel"),
        ),

        // Randomly perform every button task
        TextButton(
          onPressed: onPressed,
          child:  Text(text),
        ),
      ],
    );
  }
}
