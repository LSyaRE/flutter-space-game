import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    player = Player();

    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }
}

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  Player() : super(size: Vector2(100, 150), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
