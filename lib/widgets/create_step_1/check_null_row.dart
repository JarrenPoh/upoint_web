import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/medium_text.dart';

class CheckNullRow extends StatefulWidget {
  final String? number;
  final String hintText;
  final String index;
  final Function(String?) onChanged;
  final double padLeft;
  const CheckNullRow({
    super.key,
    required this.hintText,
    required this.number,
    required this.onChanged,
    required this.padLeft,
    required this.index,
  });

  @override
  State<CheckNullRow> createState() => _CheckNullRowState();
}

class _CheckNullRowState extends State<CheckNullRow> {
  late TextEditingController _textEditingController = TextEditingController();
  String? number;
  bool _isChecked = false;
  bool _enabaled = true;
  late String text = widget.index == "capacity"
      ? "不限人數"
      : widget.index == "link"
          ? "無參考連結"
          : "無獎勵";
  @override
  void initState() {
    super.initState();
    if (widget.number == null || widget.number == "null") {
      _textEditingController.text = text;
      _isChecked = true;
      _enabaled = false;
    } else if (widget.number != null && widget.number != "null") {
      number = widget.number!;
      _textEditingController = TextEditingController(text: number.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: widget.padLeft, bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: grey400,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                if (_enabaled == false) {
                  Messenger.snackBar(context, "請先取消選取“$text”，方可輸入文字");
                }
              },
              child: TextField(
                controller: _textEditingController,
                enabled: _enabaled,
                keyboardType:
                    widget.index == "capacity" ? TextInputType.number : null,
                inputFormatters: widget.index == "capacity"
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly, // 仅允许输入数字
                      ]
                    : null,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: grey400,
                    fontFamily: 'NotoSansMedium',
                    fontSize: 16,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
                onChanged: (e) {
                  if (_isChecked == false) {
                    widget.onChanged(e);
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(width: widget.padLeft * 2),
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Checkbox(
                value: _isChecked,
                side: BorderSide(color: grey400),
                onChanged: (ee) {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                  if (ee == true) {
                    widget.onChanged(null);
                    setState(() {
                      _textEditingController.text = text;
                      _enabaled = false;
                    });
                  } else {
                    setState(() {
                      _textEditingController.clear();
                      _enabaled = true;
                    });
                  }
                },
              ),
              MediumText(
                color: grey500,
                size: 16,
                text: text,
              )
            ],
          ),
        ),
      ],
    );
  }
}
