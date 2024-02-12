import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import '../bloc/center_bloc.dart';

class CenterPage extends StatefulWidget {
  final bool isWeb;
  final CenterBloc bloc;
  final Widget child;
  const CenterPage({
    super.key,
    required this.isWeb,
    required this.bloc,
    required this.child,
  });

  @override
  State<CenterPage> createState() => _CenterPageState();
}

class _CenterPageState extends State<CenterPage> {
  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 38),
                  Row(
                    children: [
                      const SizedBox(width: 45),
                      MediumText(
                        color: grey500,
                        size: 18,
                        text: "活動狀態",
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 30,
                    ),
                    child: widget.child,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          widget.bloc.step.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.bloc.step != 1
                                ? TapHoverContainer(
                                    padding: widget.isWeb ? 84 : 40,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    text: "回上一頁",
                                    hoverColor: grey100,
                                    color: Colors.white,
                                    borderColor: primaryColor,
                                    textColor: primaryColor,
                                  )
                                : Container(),
                            TapHoverContainer(
                              padding: widget.isWeb ? 84 : 40,
                              onTap: () {},
                              text: "下一頁",
                              color: primaryColor,
                              hoverColor: secondColor,
                              borderColor: primaryColor,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
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
