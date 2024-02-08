import 'package:flutter/material.dart';
import 'package:upoint_web/bloc/create_step_2_bloc.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/widgets/create_step_2/components/drop_down_field.dart';
import 'package:upoint_web/widgets/create_step_2/components/long_field.dart';
import 'package:upoint_web/widgets/create_step_2/components/none_decor_text_field.dart';
import 'package:upoint_web/widgets/create_step_2/components/short_field.dart';
import 'package:upoint_web/widgets/create_step_2/components/time_field.dart';

class ChoseComponents extends StatelessWidget {
  final CreateStep2Bloc bloc;
  final int l;
  final int i;
  final OptionModel option;
  const ChoseComponents({
    super.key,
    required this.bloc,
    required this.i,
    required this.l,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    Widget _widget = Container();
    Widget Function(int, String) _valueWidget = (p0, p1) => Container();
    List valueType = ["single", "multi", "drop_down", "meal", "gender"];

    switch (option.type) {
      case "date2002":
        _widget = LongField(
          type: option.type,
          content: "格式：2002-09-15",
        );
        break;
      case "date91":
        _widget = LongField(
          type: option.type,
          content: "格式：91-09-15",
        );
        break;
      case "short":
        _widget = LongField(type: option.type, content: "");
        break;
      case "detail":
        _widget = LongField(
          type: option.type,
          content: "",
        );
        break;
      case "single":
        _valueWidget = (index, attribute) => ShortField(
              attribute: attribute,
              index: index,
              option: option,
              onTextChanged: (e) => bloc.onTextChanged(
                e,
                bloc.valueNotifier.value[l].options[i],
                index,
              ),
            );
        break;
      case "multi":
        _valueWidget = (index, attribute) => ShortField(
              attribute: attribute,
              index: index,
              option: option,
              onTextChanged: (e) => bloc.onTextChanged(
                e,
                bloc.valueNotifier.value[l].options[i],
                index,
              ),
            );
        break;
      case "drop_down":
        _valueWidget = (index, attribute) => DropDownField(index: index);
        break;
      case "date":
        _widget = LongField(
          type: option.type,
          content: "格式：91-09-15",
        );
        break;
      case "time":
        _widget = const TimeField();
      case "gender":
        _valueWidget = (index, attribute) => ShortField(
              attribute: attribute,
              index: index,
              option: option,
              onTextChanged: (e) {},
            );
        break;
      case "meal":
        _valueWidget = (index, attribute) => ShortField(
              attribute: attribute,
              index: index,
              option: option,
              onTextChanged: (e) {},
            );
        break;
      default:
        _widget = Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: grey300),
            borderRadius: BorderRadius.circular(10),
          ),
        );
        break;
    }

    if (valueType.contains(option.type)) {
      if (option.type == "drop_down") {
        return Column(
          children: [
            const SizedBox(height: 5),
            NoneDecorTextField(
              attribute: "explain",
              fontSize: 14,
              index: null,
              option: option,
              onTextChanged: (e) => bloc.explainTextChanged(
                e,
                bloc.valueNotifier.value[l].options[i],
              ),
            ),
            const SizedBox(height: 5),
            LongField(
              type: option.type,
              content: "",
            ),
            valueWidget(
              (index, attribute) {
                return _valueWidget(index, attribute);
              },
              option,
            ),
          ],
        );
      } else {
        return Column(
          children: [
            const SizedBox(height: 5),
            NoneDecorTextField(
              attribute: "explain",
              fontSize: 14,
              index: null,
              option: option,
              onTextChanged: (e) => bloc.explainTextChanged(
                e,
                bloc.valueNotifier.value[l].options[i],
              ),
            ),
            const SizedBox(height: 5),
            valueWidget(
              (index, attribute) {
                return _valueWidget(index, attribute);
              },
              option,
            ),
          ],
        );
      }
    } else {
      return Column(
        children: [
          const SizedBox(height: 5),
          NoneDecorTextField(
            attribute: "explain",
            fontSize: 14,
            index: null,
            option: option,
            onTextChanged: (e) => bloc.explainTextChanged(
              e,
              bloc.valueNotifier.value[l].options[i],
            ),
          ),
          const SizedBox(height: 5),
          _widget,
        ],
      );
    }
  }

  Widget valueWidget(
    Widget Function(int index, String attribute) child,
    OptionModel option,
  ) {
    return SizedBox(
      width: 495,
      child: Wrap(
        children: List.generate(
          option.other != null ? option.body.length + 1 : option.body.length,
          (index) {
            String attribute = "";
            if (option.other != null && index == option.body.length) {
              attribute = "other";
            } else {
              attribute = "normal";
            }
            return child(index, attribute);
          },
        ),
      ),
    );
  }
}
