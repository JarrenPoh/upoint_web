import 'package:flutter/material.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/sign_form_model.dart';
import 'package:upoint_web/pages/center_sign_form_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import '../bloc/center_sign_form_bloc.dart';
import '../models/form_model.dart';
import '../models/post_model.dart';
import '../widgets/circular_loading.dart';

class CenterSignFormLayout extends StatelessWidget {
  final OrganizerModel organizer;
  final PostModel post;
  const CenterSignFormLayout({
    super.key,
    required this.organizer,
    required this.post,
  });
  @override
  Widget build(BuildContext context) {
    final CenterSignFormBloc _bloc = CenterSignFormBloc(post.postId!);
    return ResponsiveLayout(
      tabletLayout: valueWidget(
        (v) => tabletLayout(v['post'], v['form'], v['signFormList'], _bloc),
        _bloc,
      ),
      webLayout: valueWidget(
        (v) => webLayout(v['post'], v['form'], v['signFormList'], _bloc),
        _bloc,
      ),
    );
  }

  Widget valueWidget(
    Widget Function(Map) child,
    CenterSignFormBloc _bloc,
  ) {
    return ValueListenableBuilder<Map>(
      valueListenable: _bloc.postValueNotifier,
      builder: (context, value, c) {
        bool isLoading = value["isLoading"];
        PostModel? post = value["post"];
        bool? isForm = value["isForm"];
        List<FormModel>? form = value["form"];
        List<SignFormModel>? signFormList = value["signFormList"];
        if (isLoading == true) {
          return const Center(
            child: CircularLoading(),
          );
        } else {
          if (post == null || isForm == false) {
            return const Center(child: Text("page not found"));
          } else {
            return child(
                {"post": post, "form": form, "signFormList": signFormList});
          }
        }
      },
    );
  }

  Widget tabletLayout(
    PostModel post,
    List<FormModel> formList,
    List<SignFormModel> signFormList,
    CenterSignFormBloc bloc,
  ) {
    return CenterSignFormPage(
      isWeb: false,
      signFormList: signFormList,
      bloc: bloc,
      formList: formList,
      post: post,
    );
  }

  Widget webLayout(
    PostModel post,
    List<FormModel> formList,
    List<SignFormModel> signFormList,
    CenterSignFormBloc bloc,
  ) {
    return CenterSignFormPage(
      isWeb: true,
      signFormList: signFormList,
      bloc: bloc,
      formList: formList,
      post: post,
    );
  }
}
