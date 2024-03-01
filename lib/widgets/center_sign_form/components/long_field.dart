import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/globals/custom_messengers.dart';
import 'package:upoint_web/globals/time_transfer.dart';
import 'package:upoint_web/models/option_model.dart';

import '../../../globals/medium_text.dart';

class LongField extends StatefulWidget {
  final OptionModel option;
  const LongField({
    super.key,
    required this.option,
  });

  @override
  State<LongField> createState() => _LongFieldState();
}

class _LongFieldState extends State<LongField> {
  late bool isDetail = widget.option.type == "detail";
  late TextEditingController _controller=TextEditingController(text: null);
  List iconList = ["date", "date2002", "date91", "time"];
  @override
  void initState() {
    super.initState();
  }

  Widget choseIcon() {
    if (widget.option.type == "time") {
      return Container(
        height: 24,
        width: 24,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/edit_clock.png"),
          ),
        ),
      );
    } else if (widget.option.type == "drop_down") {
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

  onTap(String? text) async {
    if (widget.option.type == "time") {
      await _selectTime(context);
    } else if (widget.option.type == "drop_down") {
      setState(() {
        _controller.text = text ?? "";
      });
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
        if (widget.option.type == "date2002") {
          _text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        } else {
          _text = TimeTransfer.convertToROC(selectedDate!);
        }
        _controller = TextEditingController(text: _text);
      });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: isDetail ? 120 : 48,
            padding: EdgeInsets.only(left: 17, right: 11),
            decoration: BoxDecoration(
              border: Border.all(color: grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: widget.option.type == "detail"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.option.type == "drop_down"
                    ? Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            customButton: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MediumText(
                                  color: grey500,
                                  size: 16,
                                  text: _controller.text,
                                ),
                                choseIcon(),
                              ],
                            ),
                            hint: Text(
                              '請擇一',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: _controller.text == ""
                                ? null
                                : _controller.text,
                            isExpanded: true,
                            onChanged: (value) => onTap(value),
                            items: widget.option.body
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: MediumText(
                                      color: grey500,
                                      size: 16,
                                      text: e,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: !iconList.contains(widget.option.type),
                          keyboardType:
                              isDetail ? TextInputType.multiline : null,
                          maxLines: isDetail ? 20 : 1,
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
                        ),
                      ),
                if (iconList.contains(widget.option.type))
                  Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => onTap(null),
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
