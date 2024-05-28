import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/sign_form_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/sign_form/components/login_button_group.dart';
import 'package:upoint_web/widgets/tap_hover_container.dart';
import '../../../globals/custom_messengers.dart';
import '../../../globals/regular_text.dart';
import '../../../models/form_model.dart';
import '../components/option_row.dart';

class SignFormRightLayout extends StatelessWidget {
  final List<FormModel> formList;
  final SignFormBloc bloc;
  final String postId;
  SignFormRightLayout({
    super.key,
    required this.formList,
    required this.bloc,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    onTap() {
      String? errorText = bloc.checkFunc(formList);
      if (errorText != null) {
        Messenger.dialog("有欄位尚未填寫完畢", errorText, context);
      } else {
        bloc.confirmSend(postId, context);
      }
    }

    var _count = 0;

    return Container(
      width: 543,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 73,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              color: grey100,
            ),
            child: Center(
              child: MediumText(
                color: grey500,
                size: 16,
                text: '報名表單',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: List.generate(
                formList.length,
                (index) {
                  return Column(
                    children: [
                      const SizedBox(height: 36),
                      _title(formList[index].title),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(
                          formList[index].options.length,
                          (i) {
                            _count++;
                            return OptionRow(
                              option: formList[index].options[i],
                              bloc: bloc,
                              index: _count - 1,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 45),
          Divider(color: grey300),
          // 用戶登入
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: RegularText(
                    color: grey500,
                    size: 16,
                    text: "# 登入 UPoint 帳號保存活動紀錄",
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: bloc.loginBtnValue,
                    builder: (context, value, child) {
                      int? v = value;
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        runSpacing: 15,
                        children: List.generate(
                          bloc.choseLoginButtonGroup.length,
                          (index) {
                            Map ref = bloc.choseLoginButtonGroup[index];
                            return ChoseLoginButton(
                              user: bloc.user,
                              text: ref["text"],
                              isActive: v == index,
                              onTap: () => bloc.tapLoginBtn(
                                index: ref["index"],
                                context: context,
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
          const SizedBox(height: 37),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 185,
                height: 39,
                child: TapHoverContainer(
                  text: "送出",
                  padding: 12,
                  hoverColor: secondColor,
                  borderColor: Colors.transparent,
                  textColor: Colors.white,
                  color: primaryColor,
                  onTap: () {
                    onTap();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 22,
          color: primaryColor,
        ),
        const SizedBox(width: 12),
        MediumText(
          color: grey500,
          size: 18,
          text: text,
        ),
      ],
    );
  }
}
