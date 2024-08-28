import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/inform_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';

class InformPage extends StatefulWidget {
  final bool isWeb;
  final OrganizerModel organizer;
  final InformBloc bloc;
  final Widget child;
  const InformPage({
    super.key,
    required this.isWeb,
    required this.bloc,
    required this.child,
    required this.organizer,
  });

  @override
  State<InformPage> createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
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
                  Container(
                    width: 170,
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: MediumText(
                        color: Colors.white,
                        size: 18,
                        text: "主辦單位資訊",
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isWeb ? 145 : 80,
                        ),
                        child: widget.child,
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                      valueListenable: widget.bloc.isEditValue,
                      builder: (context, value, child) {
                        if (!value) {
                          return Container();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TapHoverContainer(
                              text: "確認修改",
                              padding: widget.isWeb ? 84 : 22,
                              hoverColor: secondColor,
                              borderColor: Colors.transparent,
                              textColor: Colors.white,
                              color: primaryColor,
                              onTap: () => widget.bloc.changeEdit(
                                widget.organizer.uid,
                                context,
                              ),
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
