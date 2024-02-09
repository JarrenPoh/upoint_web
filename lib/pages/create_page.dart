import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/widgets/progress_step_widget.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class CreatePage extends StatefulWidget {
  final Widget child;
  final int step;
  final bool isWeb;
  final Function nextStep;
  const CreatePage({
    super.key,
    required this.child,
    required this.step,
    required this.isWeb,
    required this.nextStep,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
  }

  late Function(BuildContext context) onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                width: widget.isWeb ? 1076 : 543,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 進度條
                        ProgressStepWidget(iniStep: widget.step),
                      ],
                    ),
                    const SizedBox(height: 55),
                    widget.child,
                    // 送出報名
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.step == 2
                            ? TapHoverContainer(
                                padding: widget.isWeb ? 84 : 40,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                text: "回活動資訊",
                                hoverColor: grey100,
                                color: Colors.white,
                                borderColor: primaryColor,
                                textColor: primaryColor,
                              )
                            : Container(),
                        TapHoverContainer(
                          padding: widget.isWeb ? 84 : 40,
                          onTap: () => widget.nextStep(),
                          text: widget.step != 3 ? "下一步" : "確定",
                          color: primaryColor,
                          hoverColor: secondColor,
                          borderColor: primaryColor,
                          textColor: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
