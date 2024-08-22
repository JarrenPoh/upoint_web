import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'ice_block_model.dart';

class GamePageBloc {
  double angle = 0; // 珍珠旋轉的角度
  double radius = 100; // 珍珠旋轉的半徑
  double centerX; // 畫布中心X座標
  double centerY; // 畫布中心Y座標
  double pearlRadius = 15; // 珍珠的半徑
  double rotationSpeed = 0; // 珍珠旋轉速度
  List<IceBlock> iceBlocks = []; // 冰塊的列表
  List<IceShard> iceShards = []; // 碎冰塊的列表
  int score = 0; // 分數
  double teaHeight = 0; // 奶茶高度
  double maxTeaHeight; // 最大奶茶高度
  bool isColliding = false; // 是否碰撞標記
  int collisionTimer = 0; // 碰撞計時器
  late Timer iceBlockTimer; // 冰塊生成計時器
  late AnimationController controller; // 動畫控制器
  final Function resetGame;
  final Function showCountdown; // 用于显示倒计时
  int level = 0;
  late double iceSpeed = 5.0; // 冰塊下降速度
  late double bubbleSpeed = 0.075; // 珍珠旋轉速度
  int countDown = 3;
  bool isCountDown = false;

  GamePageBloc(
    this.centerX,
    this.centerY,
    this.maxTeaHeight,
    this.resetGame,
    this.showCountdown,
  );

  void update() {
    if (isColliding) {
      collisionTimer++;
      updateIceShards(); // 更新碎冰塊狀態
      if (collisionTimer >= 120) {
        resetGame(); // 刷新
      }
    } else {
      angle += rotationSpeed; // 更新珍珠旋轉角度
      final x1 = centerX + cos(angle) * radius;
      final y1 = centerY + sin(angle) * radius;
      final x2 = centerX + cos(angle + pi) * radius;
      final y2 = centerY + sin(angle + pi) * radius;

      for (int i = iceBlocks.length - 1; i >= 0; i--) {
        final block = iceBlocks[i];
        block.y += iceSpeed; // 冰塊向下移動
        // 檢測珍珠與冰塊碰撞
        if (checkCollision(x1, y1, block) || checkCollision(x2, y2, block)) {
          isColliding = true;
          createIceShatter(
              block.x, block.y, block.width, block.height); // 創建碎冰塊效果
          iceBlocks.removeAt(i);
        } else if (block.y > centerY * 2) {
          iceBlocks.removeAt(i);
        }
      }
      if (!isCountDown) {
        teaHeight = min(maxTeaHeight, teaHeight + 0.6); // 增加奶茶高度
      }
      score = teaHeight.toInt(); // 增加分數

      // 檢查是否需要升級
      if (level == 0 && score >= 500 && !isCountDown) {
        showLevelUp(0);
      } else if (level == 1 && score >= 1000 && !isCountDown) {
        showLevelUp(1);
      } else if (level == 2 && score >= 1500 && !isCountDown) {
        showLevelUp(2);
      } else if (level == 3 && score >= 2000 && !isCountDown) {
        showLevelUp(3);
      } else if (level == 4 && score >= 3000 && !isCountDown) {
        showLevelUp(4);
      }
    }
  }

  void showLevelUp(int index) {
    isCountDown = true;
    showCountdown(true);
    iceBlocks = [];
    angle = 0;
    rotationSpeed = 0;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      countDown--;
      showCountdown(true);
      if (countDown < 1) {
        isCountDown = false;
        showCountdown(false);
        timer.cancel();
        level = index + 1;
        levelUp();
        countDown = 3;
      }
    });
  }

  bool checkCollision(double pearlX, double pearlY, IceBlock block) {
    // 檢查珍珠的圓周是否與冰塊的邊界相交
    double closestX = pearlX.clamp(block.x, block.x + block.width);
    double closestY = pearlY.clamp(block.y, block.y + block.height);

    double distanceX = pearlX - closestX;
    double distanceY = pearlY - closestY;

    return (distanceX * distanceX + distanceY * distanceY) <
        (pearlRadius * pearlRadius);
  }

  // 添加冰塊
  void addIceBlock() {
    if (!isColliding && iceBlocks.length < 5) {
      final isLeft = Random().nextBool();
      final iceWidth = centerX * 0.9;
      final leftIceX = centerX / 2 - iceWidth / 2;
      final rightIceX = centerX * 1.5 - iceWidth / 2;
      iceBlocks.add(IceBlock(
        x: isLeft ? leftIceX : rightIceX,
        y: -20,
        width: iceWidth,
        height: 30,
      ));
    }
  }

  // 創建碎冰塊效果
  void createIceShatter(double x, double y, double width, double height) {
    for (int i = 0; i < 50; i++) {
      iceShards.add(IceShard(
        x: x + Random().nextDouble() * width,
        y: y + Random().nextDouble() * height,
        vx: (Random().nextDouble() - 0.5) * 5,
        vy: (Random().nextDouble() - 0.5) * 5,
        size: Random().nextDouble() * 4 + 1,
        opacity: 1,
      ));
    }
  }

  // 更新碎冰塊狀態
  void updateIceShards() {
    for (int i = iceShards.length - 1; i >= 0; i--) {
      final shard = iceShards[i];
      shard.x += shard.vx;
      shard.y += shard.vy;
      shard.opacity -= 0.02;
      if (shard.opacity <= 0) {
        iceShards.removeAt(i);
      }
    }
  }

  void levelUp() {
    // 冰塊下降速度 iceSpeed = 6.5;
    iceSpeed = speedList[level][0];
    // 珍珠旋轉速度 bubbleSpeed = 0.08;
    bubbleSpeed = speedList[level][1];
  }

  List<List> speedList = [
    [5.0, 0.075],
    [7.0, 0.085],
    [9.5, 0.09],
    [12.0, 0.12],
    [15.0, 0.14],
  ];
}
