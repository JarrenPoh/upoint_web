import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';
import 'package:upoint_web/models/option_model.dart';

class ShortField extends StatefulWidget {
  final OptionModel option;
  final List initList;
  const ShortField({
    super.key,
    required this.option,
    required this.initList,
  });

  @override
  State<ShortField> createState() => _ShortFieldState();
}

class _ShortFieldState extends State<ShortField> {
  String choseText = "";
  List radioList = ["gender", "meal", "single"];
  onTap(String text) {
    if (radioList.contains(widget.option.type)) {
      //單選只能有一個
      widget.initList.clear();
      widget.initList.add(text);
    } else {
      //多選要先看是不是有了
      if (widget.initList.contains(text)) {
        //移除
        widget.initList.removeWhere((e) => e == text);
      } else {
        //新增
        widget.initList.add(text);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 15,
      children: List.generate(
        widget.option.body.length,
        (index) {
          bool isActive = widget.initList.contains(widget.option.body[index]);
          return Container(
            height: 44,
            margin: const EdgeInsets.only(right: 22),
            decoration: BoxDecoration(
              border: Border.all(color: grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => onTap(widget.option.body[index]),
                  child: Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        radioList.contains(widget.option.type) ? 10 : 5,
                      ),
                      border: Border.all(
                        color: isActive ? primaryColor : grey300,
                      ),
                    ),
                    child: Icon(
                      radioList.contains(widget.option.type)
                          ? Icons.circle
                          : Icons.check,
                      size: 10,
                      color: isActive ? primaryColor : Colors.transparent,
                    ),
                  ),
                ),
                MediumText(
                  color: grey500,
                  size: 16,
                  text: widget.option.body[index],
                ),
                const SizedBox(width: 7),
              ],
            ),
          );
        },
      ),
    );
  }
}
