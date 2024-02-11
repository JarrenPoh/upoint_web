import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:upoint_web/color.dart';

class QuillField extends StatefulWidget {
  final Function(Delta) onQuillChanged;
  final String? text;
  const QuillField({
    super.key,
    required this.onQuillChanged,
    required this.text,
  });

  @override
  State<QuillField> createState() => _QuillFieldState();
}

class _QuillFieldState extends State<QuillField> {
  QuillController _controller = QuillController.basic();
  bool needHint = true;
  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      print(widget.text);
      _controller.document = Document.fromJson(jsonDecode(widget.text!));
      needHint = false;
    }
    _controller.addListener(_documentChange);
  }

  @override
  void dispose() {
    // 移除监听器
    _controller.removeListener(_documentChange);
    super.dispose();
  }

  void _documentChange() {
    Delta delta = _controller.document.toDelta();
    widget.onQuillChanged(delta);
    if (_controller.document.length != 1 && needHint == true) {
      setState(() {
        needHint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            controller: _controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: grey300),
            ),
          ),
          child: Stack(
            children: [
              if (needHint) // Document is empty
                const Positioned(
                  left: 0,
                  top: 0,
                  child: Text(
                    '请输入文本...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              SizedBox(
                height: 300,
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _controller,
                    readOnly: false,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('en'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
