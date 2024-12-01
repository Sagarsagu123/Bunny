import 'package:flutter/material.dart';

class CustomizedCountStepper extends StatelessWidget {
  final int initialValue;
  final int maxValue;
  final bool hasBackground;
  final Function(int) onPressed;

  const CustomizedCountStepper(
      {super.key,
      required this.initialValue,
      required this.maxValue,
      required this.onPressed,
      required this.hasBackground});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFAF6CDA), // Background color
            ),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.remove),
              iconSize: 15,
              splashRadius: 15,
              onPressed: () {
                if (initialValue > 0) {
                  onPressed(initialValue - 1);
                }
              },
            ),
          ),
          Text(
            '$initialValue',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xff868889)),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFAF6CDA), // Background color
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              splashRadius: 16,
              iconSize: 15,
              onPressed: () {
                if (initialValue < maxValue) {
                  onPressed(initialValue + 1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
