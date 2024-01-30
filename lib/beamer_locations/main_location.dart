// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';
import 'package:upoint_web/models/form_model.dart';
import 'package:upoint_web/models/option_model.dart';
import 'package:upoint_web/pages/create_page.dart';
import 'package:upoint_web/pages/create_step_1.dart';
import 'package:upoint_web/pages/create_step_2.dart';
import 'package:upoint_web/widgets/custom_navigation_bar.dart';

class MainLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/main/inform',
        '/main/center',
        '/main/create/step1',
        '/main/create/step2',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    var screenSize = MediaQuery.of(context).size;
    int currentStep = 1;
    void onIconTapped(int index) {
      String url = '';
      if (index == 0) {
        url = "/inform";
      } else if (index == 1) {
        url = "/center";
      } else {
        url = "/create/step$currentStep";
      }
      Beamer.of(context).beamToNamed('/main' + url);
    }

    Widget page = Center(child: Text("page not found"));
    Uri uri = state.toRouteInformation().uri;
    print('uri: $uri');
    if (uri.pathSegments.contains('inform')) {
      page = Test();
    } else if (uri.pathSegments.contains('center')) {
      page = Container();
    } else if (uri.pathSegments.contains('create')) {
      String step = uri.pathSegments[2];
      // final step = state.pathParameters['step'] ?? '0';
      switch (step) {
        case 'step1':
          page =const CreatePage(
            child: CreateStep1(iniStep: 0),
          );
          break;
        case 'step2':
          page =const CreatePage(
            child: CreateStep2(iniStep: 1),
          );
          break;
      }
    }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 80),
            child: CustomNavigationBar(
              onIconTapped: onIconTapped,
            ),
          ),
          body: page,
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final ValueNotifier<List<FormModel>> _valueNotifier = ValueNotifier([
    FormModel(
      title: "A",
      options: [
        OptionModel(
          type: "1",
          subtitle: "1",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "2",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "3",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
      ],
    ),
    FormModel(
      title: "B",
      options: [
        OptionModel(
          type: "1",
          subtitle: "4",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "5",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "6",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
      ],
    ),
    FormModel(
      title: "C",
      options: [
        OptionModel(
          type: "1",
          subtitle: "7",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "8",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
        OptionModel(
          type: "1",
          subtitle: "9",
          necessary: false,
          explain: "1",
          other: "1",
          body: ["1"],
        ),
      ],
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (context, value, child) {
            List<Map> _options = [];
            List _lengths = [];
            int _varI = 0;
            for (var i = 0; i < value.length; i++) {
              int varInt = value[i].title == "基本資料" ? 0 : 1;
              _options.add({
                "title": value[i].title,
                "lindex": null,
                "index": null,
                "i": _varI,
              });
              _varI++;
              for (var l = 0; l < value[i].options.length; l++) {
                _options.add({
                  "title": value[i].options[l].subtitle,
                  "lindex": i,
                  "index": l,
                  "i": _varI,
                });
                _varI++;
              }
              _lengths.add(
                value[i].options.length +
                    (_lengths.isEmpty ? 0 : _lengths.last) +
                    varInt,
              );
            }
            // print("lengths: $_lengths");
            print("options: $_options");
            return ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 500),
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                if (_lengths.contains(oldIndex)) {
                  print('是標題不能移動');
                } else {
                  if (newIndex > oldIndex) {
                    newIndex -= 1; // 这是因为在移动过程中，拖动的项已被从列表中移除
                  }
                  print('oldIndex:$oldIndex');
                  print('newIndex:$newIndex');
                  var oldMap = _options.firstWhere((e) => e["i"] == oldIndex);
                  var newMap = _options.firstWhere((e) => e["i"] == newIndex);
                  OptionModel theOption = _valueNotifier
                      .value[oldMap["lindex"]].options[oldMap["index"]];
                  print('oldMap: $oldMap');
                  print('newMap: $newMap');
                  print('theOption: ${theOption.toJson()}');
                  _valueNotifier.value[oldMap["lindex"]].options
                      .removeAt(oldMap["index"]);
                  _valueNotifier.value[newMap["lindex"]].options
                      .insert(newMap["index"], theOption);
                  // ignore: invalid_use_of_visible_for_testing_member
                  _valueNotifier.notifyListeners();
                }
              },
              children: List.generate(_options.length, (index) {
                if (index == 0) {
                  return Container(
                    key: ValueKey(index.toString()),
                  );
                }
                if (_lengths.contains(index)) {
                  return ListTile(
                    key: ValueKey(index.toString()),
                    title: Text(_options[index]["title"]),
                    // 其他 ListTile 设置...
                  );
                } else {
                  return ListTile(
                    key: ValueKey(index.toString()),
                    title: Text(_options[index]["title"]),
                    // 其他 ListTile 设置...
                  );
                }
              }),
            );
          }),
    );
  }
}
