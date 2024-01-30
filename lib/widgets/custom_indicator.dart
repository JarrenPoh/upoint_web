
import 'package:flutter/material.dart';
import 'package:upoint_web/color.dart';

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter();
  }
}

class _CustomPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = primaryColor // 指示器颜色
      ..style = PaintingStyle.fill;

    // 创建一个圆角矩形作为指示器
    final Rect rect = Offset(offset.dx, configuration.size!.height - 7) & 
      Size(configuration.size!.width, 7); // 指示器大小
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(10)); // 圆角半径

    canvas.drawRRect(rrect, paint);
  }
}