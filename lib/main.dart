import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Player()
      ..position = size / 2
      ..width = 50
      ..height = 50
      ..anchor = Anchor.center,
      );
  }
}

class Player extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
