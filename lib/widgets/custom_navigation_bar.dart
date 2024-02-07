import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/regular_text.dart';

class CustomNavigationBar extends StatefulWidget {
  // final double opacity;
  final bool isForm;
  final Function onIconTapped;
  const CustomNavigationBar({
    super.key,
    required this.onIconTapped,
    required this.isForm,
    // required this.opacity,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final List<Map> tapContainerList = [
    {
      "title": "主辦資訊",
      "isHover": false,
      "isSelected": true,
    },
    {
      "title": "活動中心",
      "isHover": false,
      "isSelected": false,
    },
    {
      "title": "建活動",
      "isHover": false,
      "isSelected": false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // 陰影顏色
                spreadRadius: 1, // 陰影範圍
                blurRadius: 1, // 模糊半徑
                offset: Offset(0, 1), // 陰影位置的偏移量
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenSize.width / 10,
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'U',
                              style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                                fontFamily: 'NotoSansBold',
                              ),
                            ),
                            TextSpan(
                              text: 'Point',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontFamily: 'NotoSansBold',
                              ),
                            ),
                            if (widget.isForm)
                              TextSpan(
                                text: " 報名系統",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: grey500,
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [],
                        ),
                      ),
                      if (!widget.isForm)
                        Row(
                          children: List.generate(
                            tapContainerList.length,
                            (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: tapContainer(
                                  tapContainerList,
                                  index,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 5.0, // 設置容器高度為 5
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [secondColor, Color(0xFFFDD854)], // 這裡可以自定義您想要的顏色
            ),
          ),
        ),
      ],
    );
  }

  Widget tapContainer(List list, int index) {
    return InkWell(
      onHover: (value) {
        setState(() {
          value
              ? list[index]['isHover'] = true
              : list[index]['isHover'] = false;
        });
      },
      onTap: () {
        setState(() {
          for (var i = 0; i < list.length; i++) {
            if (i == index) {
              list[index]['isSelected'] = true;
            } else {
              list[i]['isSelected'] = false;
            }
          }
          widget.onIconTapped(index);
        });
      },
      child: Container(
        height: 37,
        // width: 86,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: index == 2
              ? list[index]['isHover']
                  ? secondColor
                  : primaryColor
              : list[index]['isSelected']
                  ? grey100
                  : list[index]['isHover']
                      ? grey100
                      : Colors.white,
        ),
        child: Center(
          child: Row(
            children: [
              if (index == 2)
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              SizedBox(width: 4),
              RegularText(
                color: index == 2 ? Colors.white : Colors.black,
                size: 16,
                text: list[index]['title'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
