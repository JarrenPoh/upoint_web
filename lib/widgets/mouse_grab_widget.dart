import 'package:flutter/material.dart';

class MouseGrabWidget extends StatefulWidget {
  final Widget child;
  const MouseGrabWidget({
    super.key,
    required this.child,
  });

  @override
  State<MouseGrabWidget> createState() => _MouseGrabWidgetState();
}

class _MouseGrabWidgetState extends State<MouseGrabWidget> {
  bool _isGrabbing = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        cursor:
            _isGrabbing ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: Listener(
          onPointerDown: (_) => setState(() => _isGrabbing = true),
          onPointerUp: (_) => setState(() => _isGrabbing = false),
          child: widget.child,
        ),
      ),
    );
  }
}
