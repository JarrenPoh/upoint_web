import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/widgets/progress_step_widget.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class CreatePage extends StatefulWidget {
  final Widget child;
  final int step;
  final bool isWeb;
  const CreatePage({
    super.key,
    required this.child,
    required this.step,
    required this.isWeb,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  void initState() {
    super.initState();
    onTap = (BuildContext context) {
      if (widget.step == 1) {
        return Beamer.of(context).beamToNamed('/main/create/step2');
      } else {
        return Beamer.of(context).beamToNamed('/main/create/step1');
      }
    };
  }

  late Function(BuildContext context) onTap;
  @override
  Widget build(BuildContext context) {
    print('這裡');

    return Row(
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
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 64),
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
                  const SizedBox(height: 108),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.step == 1
                          ? Container()
                          : TapHoverContainer(
                              padding: widget.isWeb ? 84 : 40,
                              onTap: () {
                                Beamer.of(context)
                                    .beamToNamed('/main/create/step1');
                              },
                              text: "回活動資訊",
                              hoverColor: grey100,
                              color: Colors.white,
                              borderColor: primaryColor,
                              textColor: primaryColor,
                            ),
                      TapHoverContainer(
                        padding: widget.isWeb ? 84 : 40,
                        onTap: () {
                          onTap(context);
                        },
                        text: "下一步",
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
    );
  }
}
