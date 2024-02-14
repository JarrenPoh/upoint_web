import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/time_transfer.dart';

class LongField extends StatefulWidget {
  final String initText;
  final String type;
  final Function(String) onChanged;
  const LongField({
    super.key,
    required this.type,
    required this.initText,
    required this.onChanged,
  });

  @override
  State<LongField> createState() => _LongFieldState();
}

class _LongFieldState extends State<LongField> {
  late double height;
  late TextEditingController _controller;
  List iconList = ["date", "date2002", "date91", "drop_down", "time"];
  @override
  void initState() {
    super.initState();
    height = widget.type == "detail" ? 120 : 48;
    _controller = TextEditingController(text: widget.initText);
  }

  Widget choseIcon() {
    if (widget.type == "time") {
      return Container(
        height: 24,
        width: 24,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/edit_clock.png"),
          ),
        ),
      );
    } else if (widget.type == "drop_down") {
      return Icon(
        Icons.keyboard_arrow_down,
        color: grey300,
        size: 24,
      );
    } else {
      return Icon(
        Icons.calendar_month,
        color: grey300,
        size: 24,
      );
    }
  }

  onTap() async {
    if (widget.type == "time") {
      await _selectTime(context);
    } else if (widget.type == "drop_down") {
    } else {
      await _selectDate(context);
    }
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await Messenger.selectDate(context, selectedDate);
    String _text = "";
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (widget.type == "date2002") {
          _text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        } else {
          _text = TimeTransfer.convertToROC(selectedDate!);
        }
        _controller = TextEditingController(text: _text);
      });
      widget.onChanged(_controller.text);
    }
  }

  //選時間
  TimeOfDay? selectedTime;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await Messenger.selectTime(context, selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        String _text = TimeTransfer.timeTrans01(context, selectedTime!);
        _controller = TextEditingController(text: _text);
      });
      widget.onChanged(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            padding: EdgeInsets.only(left: 17, right: 11),
            decoration: BoxDecoration(
              border: Border.all(color: grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: widget.type == "detail"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !iconList.contains(widget.type),
                    style: TextStyle(
                      color: grey500,
                      fontSize: 16,
                      fontFamily: "NotoSansRegular",
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0),
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (e) => widget.onChanged(e),
                  ),
                ),
                if (iconList.contains(widget.type))
                  Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => onTap(),
                          child: choseIcon(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
