import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/center_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/widgets/center/layouts/center_bar_layout.dart';
import 'package:upoint_web/widgets/center/layouts/center_pic_layout.dart';
import 'package:upoint_web/widgets/center/layouts/center_inform_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';

import '../models/post_model.dart';
import '../pages/center_page.dart';
import '../widgets/circular_loading.dart';

class CenterLayout extends StatelessWidget {
  final OrganizerModel organizer;
  const CenterLayout({
    super.key,
    required this.organizer,
  });
  @override
  Widget build(BuildContext context) {
    final CenterBloc _bloc = CenterBloc(organizer);
    return ResponsiveLayout(
      tabletLayout: valueWidget(
        (v) => tabletLayout(_bloc, v),
        _bloc,
      ),
      webLayout: valueWidget(
        (v) => webLayout(_bloc, v),
        _bloc,
      ),
    );
  }

  Widget valueWidget(
    Widget Function(List<PostModel>?) child,
    CenterBloc _bloc,
  ) {
    return ValueListenableBuilder(
      valueListenable: _bloc.postValueNotifier,
      builder: ((context, value, c) {
        return child(value);
      }),
    );
  }

  Widget tabletLayout(
    CenterBloc _bloc,
    List<PostModel>? v,
  ) {
    return CenterPage(
      isWeb: false,
      bloc: _bloc,
      child: Builder(builder: (context) {
        if (v == null) {
          return const Center(
            child: CircularLoading(),
          );
        } else if (v.isEmpty) {
          return Center(
            child: MediumText(
              color: grey500,
              size: 16,
              text: "無活動",
            ),
          );
        } else {
          return Column(
            children: List.generate(
              v.length,
              (index) {
                return Column(
                  children: [
                    CenterPicLayout(
                      post: v[index],
                      width: double.infinity,
                    ),
                    CenterInformLayout(
                      post: v[index],
                      width: double.infinity,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          );
        }
      }),
    );
  }

  Widget webLayout(
    CenterBloc _bloc,
    List<PostModel>? v,
  ) {
    return CenterPage(
      isWeb: true,
      bloc: _bloc,
      child: Builder(
        builder: (context) {
          if (v == null) {
            return const Center(
              child: CircularLoading(),
            );
          } else if (v.isEmpty) {
            return Center(
              child: MediumText(
                color: grey500,
                size: 16,
                text: "無活動",
              ),
            );
          } else {
            return Column(
              children: List.generate(
                v.length,
                (index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CenterPicLayout(
                                  post: v[index],
                                  width: 300,
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: CenterInformLayout(
                                    post: v[index],
                                    width: null,
                                  ),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ),
                          if (v[index].form != null)
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CenterBarLayout(
                                post: v[index],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
