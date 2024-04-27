import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: secondColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          color: Colors.black12,
        ),
      ),
    );
  }
}
