import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/firebase/firestore_methods.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/pages/edit_page.dart';
import 'package:upoint_web/widgets/create_step_1/create_step_1_body_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'dart:html';

class CenterPostEditLayout extends StatefulWidget {
  final OrganizerModel organizer;
  final PostModel post;
  const CenterPostEditLayout({
    super.key,
    required this.organizer,
    required this.post,
  });

  @override
  State<CenterPostEditLayout> createState() => _CenterPostEditLayoutState();
}

class _CenterPostEditLayoutState extends State<CenterPostEditLayout> {
  late CreateStep1Bloc _bloc;
  @override
  void initState() {
    super.initState();
    // post 中timeStamp先轉換成可被編輯日期接收的String
    if (widget.post.startDateTime is Timestamp) {
      widget.post.startDateTime = DateFormat("yyyy-MM-dd/h:mm a")
          .format((widget.post.startDateTime as Timestamp).toDate());
      widget.post.endDateTime = DateFormat("yyyy-MM-dd/h:mm a")
          .format((widget.post.endDateTime as Timestamp).toDate());
    }
    _bloc = CreateStep1Bloc(
      post: widget.post,
      isEdit: true,
      organizer: widget.organizer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(_bloc, context),
      webLayout: webLayout(_bloc, context),
    );
  }

  Widget tabletLayout(
    CreateStep1Bloc _bloc,
    BuildContext context,
  ) {
    return EditPage(
      isWeb: false,
      title: "編輯貼文",
      child: CreateStep1BodyLayout(isWeb: false, bloc: _bloc),
      send: () => send(),
    );
  }

  Widget webLayout(
    CreateStep1Bloc _bloc,
    BuildContext context,
  ) {
    return EditPage(
      isWeb: true,
      title: "編輯貼文",
      child: CreateStep1BodyLayout(isWeb: true, bloc: _bloc),
      send: () => send(),
    );
  }

  send() async {
    String? text = _bloc.checkFunc();
    if (text != null) {
      Messenger.dialog("請確認填寫正確", text, context);
    } else {
      await FirestoreMethods().updatePost(_bloc.valueNotifier.value);
      window.location.reload();
    }
  }
}
