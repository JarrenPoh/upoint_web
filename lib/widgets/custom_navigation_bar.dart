import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/firebase/auth_methods.dart';
import 'package:upoint_web/globals/regular_text.dart';
import 'dart:html';
import '../globals/custom_messengers.dart';

class CustomNavigationBar extends StatefulWidget {
  // final double opacity;
  final bool isForm; //學生的報名表單
  final Map inform;
  final Function onIconTapped;
  const CustomNavigationBar({
    super.key,
    required this.onIconTapped,
    required this.isForm,
    required this.inform,
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
  String? pic;
  String? username;
  String? email;
  late String childname;
  @override
  void initState() {
    super.initState();
    pic = widget.inform["pic"];
    username = widget.inform["username"];
    email = FirebaseAuth.instance.currentUser?.email;
    childname = widget.isForm ? "users" : "organizers";
  }

  bool _isOverlayShown = false;
  late final OverlayEntry _overlayEntry = OverlayEntry(builder: (context) {
    List<Map> options = [
      {
        "index": "logout",
        "text": "登出",
        "onTap": () {
          _overlayEntry.remove();
          AuthMethods().signOut();
        },
        "icon": Icons.logout_outlined,
      },
      {
        "index": "delete_account",
        "text": "註銷",
        "onTap": () async {
          String _rr = await AuthMethods().deleteAccount(
            childname,
            FirebaseAuth.instance.currentUser!.uid,
          );
          if (_rr == "success") {
            Messenger.snackBar(context, "註銷成功");
            window.location.reload();
          } else {
            Messenger.snackBar(context, "註銷失敗");
            Messenger.dialog(
                "註銷失敗", "$_rr 有問題請洽詢官方：service.upoint@gmail.com", context);
          }
        },
        "icon": Icons.key_off_outlined,
      },
    ];
    return Positioned(
      top: 100, // 根据需要调整位置
      right: 20, // 根据需要调整位置
      child: Material(
        color: Colors.white, // 防止点击事件被遮挡
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: grey300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(top: 15, left: 15, right: 10, bottom: 15),
          width: 230,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: pic == null
                        ? Image.asset("assets/profile.png")
                        : Image.network(
                            pic!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegularText(
                          color: grey500,
                          size: 16,
                          text: username ?? "未登入",
                          maxLines: 2,
                        ),
                        RegularText(
                          color: grey500,
                          size: 12,
                          text: email ?? "未登入",
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: grey300),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  options.length,
                  (int index) {
                    var option = options[index];
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: option["onTap"],
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Row(
                              children: [
                                Icon(
                                  option["icon"],
                                  color: grey500,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                RegularText(
                                  color: grey500,
                                  size: 14,
                                  text: option["text"],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
  void _showOverlay(BuildContext context) {
    if (_isOverlayShown == false) {
      Overlay.of(context).insert(_overlayEntry);
    } else {
      _overlayEntry.remove();
    }
    setState(() {
      _isOverlayShown = !_isOverlayShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 500) {
      return mobileLayout();
    } else {
      return webLayout();
    }
  }

  Widget mobileLayout() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // 陰影顏色
            spreadRadius: 1, // 陰影範圍
            blurRadius: 1, // 模糊半徑
            offset: const Offset(0, 1), // 陰影位置的偏移量
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // UPoint
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
                    color: grey500,
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
          // 用戶控制
          if (FirebaseAuth.instance.currentUser != null)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _showOverlay(context);
                },
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(
                    "assets/profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget webLayout() {
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
                offset: const Offset(0, 1), // 陰影位置的偏移量
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 5,
                        child: Column(
                          children: [],
                        ),
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
                                color: grey500,
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
                      const Expanded(
                        flex: 5,
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
                      if (FirebaseAuth.instance.currentUser != null)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              _showOverlay(context);
                            },
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                "assets/profile.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      const Expanded(
                        flex: 1,
                        child: Column(
                          children: [],
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
