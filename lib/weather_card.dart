import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String time;
  final IconData icons;
  final String temp;
  const CardWidget({
    required this.time,
    required this.icons,
    required this.temp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(129, 33, 33, 33),
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icons,
                size: 30,
              ),
            ),
            Text(
              temp,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0),
            ),
          ],
        ),
      ),
    );
  }
}
