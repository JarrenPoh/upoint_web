import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/center_sign_form_bloc.dart';
import '../../color.dart';
import '../../globals/medium_text.dart';
import '../../models/sign_form_model.dart';
import '../tap_hover_container.dart';

class CenterSignFormSignList extends StatelessWidget {
  final bool isWeb;
  final List<SignFormModel>? signFormList;
  final CenterSignFormBloc bloc;
  const CenterSignFormSignList({
    super.key,
    required this.isWeb,
    required this.signFormList,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    List<Map> titleList = [
      {
        "title": "#",
        "width": isWeb ? 10 : 10,
      },
      {
        "title": "學號",
        "width": isWeb ? 75 : 35,
      },
      {
        "title": "姓名",
        "width": isWeb ? 55 : 17,
      },
      {
        "title": "聯絡電話",
        "width": isWeb ? 95 : 45,
      },
      {
        "title": "Email",
        "width": isWeb ? 250 : 70,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          width: 144,
          child: TapHoverContainer(
            text: "匯出報名資訊",
            padding: 16,
            hoverColor: grey100,
            borderColor: primaryColor,
            textColor: primaryColor,
            color: Colors.white,
            onTap: () => bloc.exportExcel(context),
          ),
        ),
        const SizedBox(height: 20),
        // 名單標題
        Container(
          height: 47,
          color: grey200,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (Map i in titleList)
                SizedBox(
                  width: i["width"],
                  child: MediumText(
                    color: grey500,
                    size: 16,
                    text: i["title"],
                  ),
                ),
            ],
          ),
        ),
        if (signFormList == null)
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediumText(color: grey500, size: 16, text: "目前還沒有人報名參加此活動")
            ],
          )),
        // 名單內容
        if (signFormList != null)
          Column(
            children: List.generate(
              signFormList!.length,
              (lindex) {
                List lllist = [];
                lllist.add((lindex + 1).toString());
                return Container(
                  height: 47,
                  color: lindex % 2 == 1 ? grey100 : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      titleList.length,
                      (index) {
                        const order = ['學號', '姓名', '聯絡電話', 'email'];
                        List<dynamic> _list =
                            jsonDecode(signFormList![lindex].body);
                        for (var field in order) {
                          var found = _list.firstWhere(
                            (element) => element['subtitle'] == field,
                            orElse: () => {"value": ""},
                          );
                          // 如果找到匹配的项，并且value不为空，则添加到orderedValues列表中
                          if (found['value'] != "") {
                            lllist.add(found['value']);
                          } else {
                            lllist.add("無");
                          }
                        }
                        return SizedBox(
                          width: titleList[index]["width"],
                          child: MediumText(
                            color: grey500,
                            size: 16,
                            text: lllist[index],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
