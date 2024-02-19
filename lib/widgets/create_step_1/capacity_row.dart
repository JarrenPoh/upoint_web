import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/medium_text.dart';

class CapacityRow extends StatefulWidget {
  final String? number;
  final String hintText;
  final Function(String?) onChanged;
  final double padLeft;
  const CapacityRow({
    super.key,
    required this.hintText,
    required this.number,
    required this.onChanged,
    required this.padLeft,
  });

  @override
  State<CapacityRow> createState() => _CapacityRowState();
}

class _CapacityRowState extends State<CapacityRow> {
  late TextEditingController _textEditingController = TextEditingController();
  String? number;
  bool _isChecked = false;
  bool _enabaled = true;
  @override
  void initState() {
    super.initState();
    if (widget.number == null) {
      _textEditingController.text = "不限人數";
      _isChecked = true;
      _enabaled = false;
    } else if (widget.number != null&&widget.number != "umlimited") {
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
            child: TextField(
              controller: _textEditingController,
              enabled: _enabaled,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // 仅允许输入数字
              ],
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
        SizedBox(width: widget.padLeft * 2),
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
                _textEditingController.text = "不限人數";
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
          text: "不限人數",
        )
      ],
    );
  }
}
