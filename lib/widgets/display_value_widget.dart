import 'package:flutter/material.dart';

class DisplayValueWidget extends StatelessWidget {
  final String title;
  final String? text;
  final bool isError;

  const DisplayValueWidget({
    super.key,
    required this.title,
    this.text,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(text: '$title: ', children: [
        TextSpan(
          text: text,
          style: TextStyle(fontWeight: FontWeight.normal, color: isError ? Colors.red.shade800 : null),
        ),
      ]),
      style: TextStyle(fontWeight: FontWeight.bold, color: isError ? Colors.red.shade800 : null),
    );
  }
}
