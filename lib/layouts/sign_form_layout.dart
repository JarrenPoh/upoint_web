import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/sign_form_bloc.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/user_model.dart';
import 'package:upoint_web/pages/sign_form_page.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/widgets/sign_form/layouts/sign_form_left_layouts.dart';
import '../color.dart';
import '../globals/medium_text.dart';
import '../widgets/sign_form/layouts/sign_form_right_layout.dart';

class SignFormLayout extends StatelessWidget {
  final String postId;
  final UserModel? user;
  const SignFormLayout({
    super.key,
    required this.postId,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final SignFormBloc _bloc = SignFormBloc(postId, user);
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
    SignFormBloc bloc,
  ) {
    return ValueListenableBuilder<Map>(
      valueListenable: bloc.postValueNotifier,
      builder: (context, value, cchild) {
        bool isLoading = value["isLoading"];
        PostModel? post = value["post"];
        bool isForm = value["isForm"];
        List<FormModel>? form = value["form"];
        if (isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (post == null || isForm == false) {
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
    List<FormModel> formList,
    SignFormBloc bloc,
  ) {
    debugPrint('切換到 tabletLayout');
    return SignFormPage(
      isWeb: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignFormLeftLayout(post: post),
          const SizedBox(height: 32),
          (post.formDateTime as Timestamp).toDate().isBefore(DateTime.now())
              ? overtimeWidget()
              : SignFormRightLayout(
                  formList: formList,
                  bloc: bloc,
                  postId: postId,
                ),
        ],
      ),
    );
  }

  Widget webLayout(
    PostModel post,
    List<FormModel> formList,
    SignFormBloc bloc,
  ) {
    debugPrint('切換到 desktopLayout');
    return SignFormPage(
      isWeb: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SignFormLeftLayout(post: post),
          (post.formDateTime as Timestamp).toDate().isBefore(DateTime.now())
              ? overtimeWidget()
              : SignFormRightLayout(
                  formList: formList,
                  bloc: bloc,
                  postId: postId,
                ),
        ],
      ),
    );
  }

  Widget overtimeWidget() {
    return SizedBox(
      width: 543,
      child: Column(
        children: [
          Container(
            width: 152,
            height: 152,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/create_failed.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 17),
          MediumText(
            color: grey500,
            size: 20,
            text: "表單已過期",
          ),
        ],
      ),
    );
  }
}
