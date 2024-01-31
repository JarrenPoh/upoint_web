import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_1_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/widgets/create_step_1/date_pick_row.dart';
import 'package:upoint_web/widgets/underscore_textfield.dart';

class CreateStep1BodyLayout extends StatelessWidget {
  final bool isWeb;
  final CreateStep1Bloc bloc;
  const CreateStep1BodyLayout({
    super.key,
    required this.isWeb,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 上傳封面照
        Column(
          children: [
            Row(
              children: [
                Container(
                  color: primaryColor,
                  width: 8,
                  height: 29,
                ),
                const SizedBox(width: 16),
                MediumText(
                  color: grey500,
                  size: 20,
                  text: '上傳封面照',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 374,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF4F4F4),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.upload_rounded,
                          color: Color(0xFF343434),
                        ),
                        iconSize: 27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 48),
        // 活動資訊
        Column(
          children: [
            Row(
              children: [
                Container(
                  color: primaryColor,
                  width: 8,
                  height: 29,
                ),
                SizedBox(width: 16),
                MediumText(
                  color: grey500,
                  size: 20,
                  text: '活動資訊',
                ),
              ],
            ),
            Column(
              children: List.generate(
                bloc.createInformList.length,
                (index) {
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: UnderscoreTextField(
                              hintText: bloc.createInformList[index]['title'],
                            ),
                          ),
                          if (bloc.createInformList[index]['index'] ==
                                  'startDate' ||
                              bloc.createInformList[index]['index'] ==
                                  'endDate')
                            DatePickRow(isWeb: isWeb),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        // 活動詳情
      ],
    );
  }
}
