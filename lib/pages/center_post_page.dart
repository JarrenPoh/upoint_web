import 'package:flutter/material.dart';

class CenterPostPage extends StatelessWidget {
  final bool isWeb;
  final Widget child;
  const CenterPostPage({
    super.key,
    required this.isWeb,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Container(
                  width: isWeb ? 1076 : 543,
                  padding:
                      const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
