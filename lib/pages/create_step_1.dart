import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'package:upoint_web/widgets/progress_step_widget.dart';

class CreateStep1 extends StatefulWidget {
  final int iniStep;
  const CreateStep1({
    super.key,
    required this.iniStep,
  });

  @override
  State<CreateStep1> createState() => _CreateStep1State();
}

class _CreateStep1State extends State<CreateStep1> {
  @override
  void initState() {
    super.initState();
  }

  List informList = [
    {
      "title": "活動名稱",
      "index": "name",
    },
    {
      "title": "活動地點",
      "index": "location",
    },
    {
      "title": "開始日期",
      "index": "startDate",
    },
    {
      "title": "結束日期",
      "index": "endDate",
    },
    {
      "title": "活動名額",
      "index": "capacitye",
    },
    {
      "title": "活動簡介",
      "index": "introduction",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
        child: Container(
          width: 1076,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 48, horizontal: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 進度條
                  ProgressStepWidget(iniStep: widget.iniStep),
                ],
              ),
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
                      SizedBox(width: 16),
                      MediumText(
                        color: grey500,
                        size: 20,
                        text: '上傳封面照',
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
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
              SizedBox(height: 48),
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
                    children: List.generate(informList.length, (index) {
                      return Column(
                        children: [
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: grey400,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: informList[index]['title'],
                                      hintStyle: TextStyle(
                                        color: grey400,
                                        fontFamily: 'NotoSansMedium',
                                        fontSize: 16,
                                      ),
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              if (informList[index]['index'] == 'startDate' ||
                                  informList[index]['index'] == 'endDate')
                                datePickRow(),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 48),
              // 活動詳情
      
              // 下一步
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    color: primaryColor,
                    onPressed: () {
                      Beamer.of(context).beamToNamed('/main/create/step2');
                    },
                    hoverColor: secondColor,
                    height: 39,
                    minWidth: 216,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 設置圓角半徑
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: MediumText(
                          color: Colors.white,
                          size: 16,
                          text: '下一步',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget datePickRow() {
    return Row(
      children: [
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 22, right: 16),
          width: 111,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: '時',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 22, right: 16),
          width: 111,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: '分',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: grey400,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 22, right: 16),
          width: 111,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RegularText(
                color: grey400,
                size: 16,
                text: 'PM',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: grey400,
                ),
                iconSize: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
