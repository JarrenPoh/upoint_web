import 'dart:math';
import 'package:flutter/material.dart';

import 'ice_block_model.dart';

class GamePainter extends CustomPainter {
  final double angle;
  final double radius;
  final double centerX;
  final double centerY;
  final double pearlRadius;
  final List<IceBlock> iceBlocks;
  final List<IceShard> iceShards;
  final double teaHeight;

  GamePainter({
    required this.angle,
    required this.radius,
    required this.centerX,
    required this.centerY,
    required this.pearlRadius,
    required this.iceBlocks,
    required this.iceShards,
    required this.teaHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final pearlPaint = Paint()
      ..color = Color(0xff4d2600)
      ..style = PaintingStyle.fill;

    final icePaint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final iceStrokePaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke;

    final teaPaint = Paint()
      ..color = Color(0xffc19a6b)
      ..style = PaintingStyle.fill;

    final teaBubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // 畫奶茶
    canvas.drawRect(Rect.fromLTWH(0, size.height - teaHeight, size.width, teaHeight), teaPaint);

    // 畫奶茶中的氣泡
    for (int i = 0; i < 50; i++) {
      canvas.drawCircle(
        Offset(Random().nextDouble() * size.width, size.height - Random().nextDouble() * teaHeight),
        Random().nextDouble() * 5,
        teaBubblePaint,
      );
    }

    // 計算珍珠位置
    final x1 = centerX + cos(angle) * radius;
    final y1 = centerY + sin(angle) * radius;
    final x2 = centerX + cos(angle + pi) * radius;
    final y2 = centerY + sin(angle + pi) * radius;

    // 畫珍珠
    canvas.drawCircle(Offset(x1, y1), pearlRadius, pearlPaint);
    canvas.drawCircle(Offset(x2, y2), pearlRadius, pearlPaint);

    // 畫冰塊，帶圓角
    iceBlocks.forEach((block) {
      final iceRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(block.x, block.y, block.width, block.height),
        Radius.circular(8), // 設定圓角半徑
      );
      canvas.drawRRect(iceRect, icePaint);
      canvas.drawRRect(iceRect, iceStrokePaint);

      // 添加高光效果
      final highlightPath = Path()
        ..moveTo(block.x + block.width * 0.2, block.y)
        ..lineTo(block.x + block.width * 0.8, block.y)
        ..lineTo(block.x + block.width, block.y + block.height * 0.2)
        ..lineTo(block.x + block.width, block.y + block.height * 0.8)
        ..lineTo(block.x + block.width * 0.8, block.y + block.height)
        ..lineTo(block.x + block.width * 0.2, block.y + block.height)
        ..lineTo(block.x, block.y + block.height * 0.8)
        ..lineTo(block.x, block.y + block.height * 0.2)
        ..close();

      final highlightPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.white.withOpacity(0.7), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(iceRect.outerRect);

      canvas.drawPath(highlightPath, highlightPaint);

      // 添加陰影效果
      final shadowPath = Path()
        ..moveTo(block.x + block.width * 0.2, block.y + block.height)
        ..lineTo(block.x + block.width * 0.8, block.y + block.height)
        ..lineTo(block.x + block.width, block.y + block.height * 0.8)
        ..lineTo(block.x + block.width, block.y + block.height * 0.2)
        ..lineTo(block.x + block.width * 0.8, block.y)
        ..lineTo(block.x + block.width * 0.2, block.y)
        ..lineTo(block.x, block.y + block.height * 0.2)
        ..lineTo(block.x, block.y + block.height * 0.8)
        ..close();

      final shadowPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(iceRect.outerRect);

      canvas.drawPath(shadowPath, shadowPaint);
    });

    // 畫碎冰塊
    iceShards.forEach((shard) {
      final shardPaint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity(shard.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(shard.x, shard.y), shard.size, shardPaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
