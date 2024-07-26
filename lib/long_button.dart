import 'package:flutter/material.dart';

// Custom Button functionality.....

class LongButton extends StatelessWidget {
  final String value;
  final double width;
  final Color color;
  final VoidCallback onPress;
  const LongButton({
    required this.value,
    required this.width,
    required this.onPress,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Container(
          height: 50,
          width: width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
              child: Text(
            value,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w500),
          )),
        ));
  }
}
