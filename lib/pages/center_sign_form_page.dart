import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/center_sign_form_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/post_model.dart';
import 'package:upoint_web/models/sign_form_model.dart';
import 'package:upoint_web/widgets/center_sign_form/layouts/center_sign_inform_sign_form.dart';
import 'package:upoint_web/widgets/center_sign_form/layouts/center_sign_inform_sign_list.dart';
import '../models/form_model.dart';

class CenterSignFormPage extends StatefulWidget {
  final bool isWeb;
  final List<SignFormModel> signFormList;
  final CenterSignFormBloc bloc;
  final PostModel post;
  final List<FormModel> formList;
  const CenterSignFormPage({
    super.key,
    required this.isWeb,
    required this.signFormList,
    required this.bloc,
    required this.post,
    required this.formList,
  });

  @override
  State<CenterSignFormPage> createState() => _CenterSignFormPageState();
}

class _CenterSignFormPageState extends State<CenterSignFormPage> {
  bool isSignList = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Container(
                  width: widget.isWeb ? 1076 : 543,
                  padding:
                      const EdgeInsets.symmetric(vertical: 66, horizontal: 64),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 篩選
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: grey200)),
                        ),
                        child: Row(
                          children: [
                            _pickWidget(
                              isSignList == true,
                              () => isSignList = true,
                              "活動名單",
                            ),
                            _pickWidget(
                              isSignList == false,
                              () => isSignList = false,
                              "報名表單",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 名單標題
                      if (isSignList)
                        CenterSignInformSignList(
                          isWeb: widget.isWeb,
                          signFormList: widget.signFormList,
                          bloc: widget.bloc,
                        ),
                      // 預覽報名表單
                      if (!isSignList)
                        CenterSignInformSignForm(
                          formList: widget.formList,
                          post: widget.post,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pickWidget(bool isActive, Function onTap, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onTap();
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          child: MediumText(
            color: isActive ? Colors.white : grey500,
            size: 18,
            text: title,
          ),
        ),
      ),
    );
  }
}
