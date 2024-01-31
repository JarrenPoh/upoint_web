import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class ProgressStepWidget extends StatefulWidget {
  final int iniStep;
  const ProgressStepWidget({
    super.key,
    required this.iniStep,
  });

  @override
  State<ProgressStepWidget> createState() => _ProgressStepWidgetState();
}

class _ProgressStepWidgetState extends State<ProgressStepWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      width: 330,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) {
                  return Row(
                    children: [
                      circleWidget(index, widget.iniStep),
                      if (index != 2)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          width: 48,
                          child: Divider(
                            color:
                                widget.iniStep > index ? primaryColor : grey200,
                            thickness: 2.1,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey500,
                size: 14,
                text: '填寫活動資訊',
              ),
              RegularText(
                color: grey500,
                size: 14,
                text: '設計報名表單',
              ),
              RegularText(
                color: grey500,
                size: 14,
                text: '建立活動！',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget circleWidget(int index, int step) {
    return Container(
      height: 42.16,
      width: 42.16,
      decoration: BoxDecoration(
        color: step == index
            ? Colors.white
            : step > index
                ? primaryColor
                : grey200,
        border: Border.all(
          color: step >= index ? primaryColor : grey200,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: TextStyle(
            color: step == index
                ? primaryColor
                : step > index
                    ? Colors.white
                    : grey500,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
