import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/pages/edit_page.dart';
import 'package:upoint_web/widgets/circular_loading.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_pick_layout.dart';
import 'package:upoint_web/widgets/responsive_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_left_layout.dart';
import 'package:upoint_web/widgets/create_step_2/layouts/create_step_2_right_layout.dart';
import 'dart:html';
import '../firebase/firestore_methods.dart';
import '../globals/custom_messengers.dart';
import '../models/option_model.dart';

class CenterFormEditLayout extends StatefulWidget {
  const CenterFormEditLayout({
    super.key,
    required this.post,
    required this.formList,
  });
  final PostModel post;
  final List<FormModel> formList;

  @override
  State<CenterFormEditLayout> createState() => _CenterFormEditLayoutState();
}

class _CenterFormEditLayoutState extends State<CenterFormEditLayout> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // post 中timeStamp先轉換成可被編輯日期接收的String
    if (widget.post.formDateTime is Timestamp) {
      widget.post.formDateTime = DateFormat("yyyy-MM-dd/h:mm a")
          .format((widget.post.formDateTime as Timestamp).toDate());
    }
    if (widget.post.remindDateTime is Timestamp &&
        widget.post.remindDateTime != null) {
      widget.post.remindDateTime = DateFormat("yyyy-MM-dd/h:mm a")
          .format((widget.post.remindDateTime as Timestamp).toDate());
    }

    // 要把多插入的fixCommon刪掉
    List<String> typesToRemove =
        fixCommon.map((option) => option.type).toList();
    widget.formList.first.options
        .removeWhere((item) => typesToRemove.contains(item.type));
    _bloc = CreateStep2Bloc(
      formModel: widget.formList,
      isEdit: true,
      post: widget.post,
    );
  }

  late CreateStep2Bloc _bloc;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      tabletLayout: tabletLayout(context, _bloc),
      webLayout: webLayout(context, _bloc),
    );
  }

  Widget tabletLayout(BuildContext context, CreateStep2Bloc _bloc) {
    debugPrint('切換到 tabletLayout');
    Widget formWidget = Column(
      children: [
        //左邊區塊
        CreateStep2LeftLayout(bloc: _bloc.createFormBloc),
        const SizedBox(height: 20),
        //右邊區塊
        CreateStep2RightLayout(bloc: _bloc.createFormBloc)
      ],
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        EditPage(
          isWeb: false,
          title: "編輯表單",
          send: () => send(),
          child: CreateStep2PickLayout(
            bloc: _bloc,
            child: formWidget,
            isWeb: false,
          ),
        ),
        if (isLoading) const CircularLoading(),
      ],
    );
  }

  Widget webLayout(BuildContext context, CreateStep2Bloc _bloc) {
    debugPrint('切換到 desktopLayout');
    Widget formWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //左邊區塊
        CreateStep2LeftLayout(bloc: _bloc.createFormBloc),
        const SizedBox(width: 24),
        //右邊區塊
        CreateStep2RightLayout(bloc: _bloc.createFormBloc)
      ],
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        EditPage(
          isWeb: true,
          title: "編輯表單",
          send: () => send(),
          child: CreateStep2PickLayout(
            bloc: _bloc,
            child: formWidget,
            isWeb: true,
          ),
        ),
        if (isLoading) const CircularLoading(),
      ],
    );
  }

  send() async {
    String? text = _bloc.checkFunc();
    if (text != null) {
      Messenger.dialog("請確認填寫正確", text, context);
    } else {
      PostModel _post = _bloc.postValue.value;
      if (_bloc.formOptionValue.value == "link") {
        _post.form = _bloc.link;
      } else if (_bloc.formOptionValue.value == "null") {
        _post.form = null;
      } else {
        _post.form = jsonEncode(_bloc.createFormBloc.valueNotifier.value
            .map((form) => form.toJson())
            .toList());
      }
      setState(() {
        isLoading = true;
      });
      await FirestoreMethods().updateForm(
        post: _post,
      );
      window.location.reload();
    }
  }

  List<OptionModel> fixCommon = [
    OptionModel(
      type: "username",
      subtitle: "姓名",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "phoneNumber",
      subtitle: "聯絡電話",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
    OptionModel(
      type: "email",
      subtitle: "email",
      necessary: true,
      explain: null,
      other: null,
      body: [""],
    ),
  ];
}
