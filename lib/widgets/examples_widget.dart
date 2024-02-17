import 'package:flutter/material.dart';
import '../consts.dart';

class ExamplesWidget extends StatelessWidget {
  final TextEditingController editingController;

  const ExamplesWidget({
    super.key,
    required this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(alignment: Alignment.centerLeft, child: Text('Examples:')),
        ...Consts.examples.map((e) {
          return SizedBox(
            height: 36,
            child: TextButton(
              onPressed: () {
                editingController.text = e;
              },
              child: Text(e),
            ),
          );
        }),
      ],
    );
  }
}
