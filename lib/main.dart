import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class Bullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  Bullet({super.position})
      : super(size: Vector2(25, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'bullet.png',
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: .2, textureSize: Vector2(8, 16)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }
}

class Player extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame> {
  late final SpawnComponent _bulletSpawner;

  Player() : super(size: Vector2(100, 150), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await gameRef.loadSpriteAnimation(
        'player.png',
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: .2, textureSize: Vector2(32, 48)));

    position = gameRef.size / 2;

    spawnFactory(index) {
      return Bullet(position: position + Vector2(0, -height / 2));
    }

    _bulletSpawner = SpawnComponent(
        period: .2,
        selfPositioning: true,
        factory: spawnFactory,
        autoStart: false);

    game.add(_bulletSpawner);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final parallax = await loadParallaxComponent([
      ParallaxImageData('stars_0.png'),
      ParallaxImageData('stars_1.png'),
      ParallaxImageData('stars_2.png'),
    ],
        baseVelocity: Vector2(0, -5),
        repeat: ImageRepeat.repeat,
        velocityMultiplierDelta: Vector2(0, 5));

    add(parallax);

    player = Player();

    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }
}
