import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icons;
  final String label;
  final String value;
  const AdditionalInfo(
      {super.key,
      required this.icons,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icons,
          size: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 17),
        )
      ],
    );
  }
}
