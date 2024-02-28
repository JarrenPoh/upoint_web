import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/center_post_bloc.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/pages/center_post_page.dart';
import 'package:upoint_web/widgets/center_post/center_post_inform_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import '../models/form_model.dart';
import '../models/post_model.dart';
import '../widgets/center_post/center_post_bar_layout.dart';

class CenterPostLayout extends StatelessWidget {
  final OrganizerModel organizer;
  final String postId;
  const CenterPostLayout({
    super.key,
    required this.organizer,
    required this.postId,
  });
  @override
  Widget build(BuildContext context) {
    final CenterPostBloc _bloc = CenterPostBloc(postId);
    return ResponsiveLayout(
      tabletLayout: valueWidget(
        (v) => tabletLayout(v['post'], v['form'], _bloc),
        _bloc,
      ),
      webLayout: valueWidget(
        (v) => webLayout(v['post'], v['form'], _bloc),
        _bloc,
      ),
    );
  }

  Widget valueWidget(
    Widget Function(Map) child,
    CenterPostBloc _bloc,
  ) {
    return ValueListenableBuilder<Map>(
      valueListenable: _bloc.postValueNotifier,
      builder: (context, value, c) {
        bool isLoading = value["isLoading"];
        PostModel? post = value["post"];
        List<FormModel>? form = value["form"];
        if (isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (post == null) {
            return const Center(child: Text("page not found"));
          } else {
            return child({"post": post, "form": form});
          }
        }
      },
    );
  }

  Widget tabletLayout(
    PostModel post,
    List<FormModel>? formList,
    CenterPostBloc bloc,
  ) {
    return CenterPostPage(
      isWeb: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF4F4F4),
                      image: DecorationImage(
                        image: NetworkImage(post.photo!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          CenterPostBarLayout(post: post),
          const SizedBox(height: 15),
          CenterPostInformLayout(post: post),
        ],
      ),
    );
  }

  Widget webLayout(
    PostModel post,
    List<FormModel>? formList,
    CenterPostBloc bloc,
  ) {
    return CenterPostPage(
      isWeb: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF4F4F4),
                      image: DecorationImage(
                        image: NetworkImage(post.photo!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 90),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CenterPostInformLayout(post: post),
              SizedBox(width: 300, child: CenterPostBarLayout(post: post)),
            ],
          ),
        ],
      ),
    );
  }
}
