import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upoint_web/games/game_painter.dart';

import 'game_page_bloc.dart';

class GamePage extends StatefulWidget {
  final double centerX;
  final double centerY;
  const GamePage({
    super.key,
    required this.centerX,
    required this.centerY,
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late GamePageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GamePageBloc(
      widget.centerX,
      widget.centerY,
      double.infinity,
      resetGame,
      _showCountdown,
    );
    // 初始化動畫控制器
    _bloc.controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // 重複動畫
    _bloc.controller.addListener(() {
      setState(() {
        _bloc.update(); // 更新遊戲狀態
      });
    });
    // 設置定時器，每650毫秒生成一個冰塊
    _bloc.iceBlockTimer =
        Timer.periodic(Duration(milliseconds: 650), (Timer timer) {
      if (!_bloc.isCountDown) {
        _bloc.addIceBlock();
      }
    });
  }

  // 顯示倒數提示
  void _showCountdown(bool show) {
    setState(() {
      _bloc.isCountDown = show;
    });
  }

  // 重置遊戲
  void resetGame() {
    setState(() {
      _bloc.iceBlocks = [];
      _bloc.iceShards = [];
      _bloc.score = 0;
      _bloc.teaHeight = 0;
      _bloc.isColliding = false;
      _bloc.collisionTimer = 0;
      _bloc.angle = 0;
      _bloc.level = 0;
      _bloc.countDown = 3;
      _bloc.iceSpeed = _bloc.speedList[_bloc.level][0];
      _bloc.bubbleSpeed = _bloc.speedList[_bloc.level][1];
    });
  }

  @override
  void dispose() {
    // 銷毀定時器和動畫控制器
    _bloc.iceBlockTimer.cancel();
    _bloc.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTapDown: (details) {
            if (!_bloc.isCountDown) {
              if (details.localPosition.dx <
                  MediaQuery.of(context).size.width / 2) {
                _bloc.rotationSpeed = -_bloc.bubbleSpeed; // 點擊左半邊，逆時針旋轉
              } else {
                _bloc.rotationSpeed = _bloc.bubbleSpeed; // 點擊右半邊，順時針旋轉
              }
            }
          },
          onTapUp: (details) {
            _bloc.rotationSpeed = 0; // 停止旋轉
          },
          child: Stack(
            children: [
              CustomPaint(
                painter: GamePainter(
                  angle: _bloc.angle,
                  radius: _bloc.radius,
                  centerX: _bloc.centerX,
                  centerY: _bloc.centerY,
                  pearlRadius: _bloc.pearlRadius,
                  iceBlocks: _bloc.iceBlocks,
                  iceShards: _bloc.iceShards,
                  teaHeight: _bloc.teaHeight,
                ),
                child: Container(),
              ),
              if (_bloc.isCountDown)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '加速倒數 ${_bloc.countDown}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 20,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      'Level ${_bloc.level + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 21, 21, 21),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_bloc.score}',
                      style: TextStyle(
                        fontSize: 42,
                        color: Color.fromARGB(255, 201, 201, 201),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
