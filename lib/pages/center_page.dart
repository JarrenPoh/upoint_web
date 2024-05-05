import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/center/components/search_status_dropdown.dart';
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
              height: widget.isWeb ? 1240 : null,
              width: widget.isWeb ? 1076 : 543,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 69,
                    child: Row(
                      children: [
                        const SizedBox(width: 45),
                        MediumText(
                          color: grey500,
                          size: 18,
                          text: "活動狀態",
                        ),
                        const SizedBox(width: 16),
                        SearchStatusDropdown(bloc: widget.bloc),
                        // const SizedBox(width: 64),
                        // MediumText(
                        //   color: grey500,
                        //   size: 18,
                        //   text: "活動日期",
                        // ),
                        // const SizedBox(width: 16),
                        // SearchTimeDropdown(bloc: widget.bloc),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        widget.child,
                        Divider(color: grey300),
                      ],
                    ),
                  ),
                  // Expanded(child: Column(children: [],)),
                  ValueListenableBuilder<Map>(
                    valueListenable: widget.bloc.pageValueNotifier,
                    builder: (context, value, child) {
                      int _currPage = value["currPage"];
                      int _allPage = value["allPage"];
                      String leftImage = _currPage == 1
                          ? "arrow_left_grey"
                          : "arrow_left_primary";
                      String rightImage = _currPage == _allPage
                          ? "arrow_right_grey"
                          : "arrow_right_primary";
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: _currPage != 1
                                    ? () =>
                                        widget.bloc.changePage(_currPage - 1)
                                    : () {},
                                child: Container(
                                  width: 27,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/$leftImage.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 23,
                              width: 38,
                              decoration: BoxDecoration(
                                border: Border.all(color: grey300),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: RegularText(
                                  color: grey500,
                                  size: 16,
                                  text: _currPage.toString(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            RegularText(
                                color: grey500,
                                size: 16,
                                text: "/ $_allPage"),
                            const SizedBox(width: 12),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: _currPage != _allPage
                                    ? () =>
                                        widget.bloc.changePage(_currPage + 1)
                                    : () {},
                                child: Container(
                                  width: 27,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/$rightImage.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
