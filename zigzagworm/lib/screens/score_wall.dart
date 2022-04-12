import 'package:flame/components.dart';
import 'package:zigzagworm/screens/game.dart';
import 'package:zigzagworm/screens/worm.dart';

class ScoreWall extends RectangleComponent
    with Collidable, HasGameRef<GameLoop> {
  ScoreWall(size, position, paint) : super(size: size, position: position, paint: paint);
  var dy = 2;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Worm) {
      gameRef.remove(this);
      gameRef.gameLoopState.incrementScore();
    }
  }

  @override
  void update(double dt) {
    position = Vector2(x, y + dy);
  }
}