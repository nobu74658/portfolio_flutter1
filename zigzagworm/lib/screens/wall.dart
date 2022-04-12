import 'package:flame/components.dart';
import 'package:zigzagworm/screens/game.dart';
import 'package:zigzagworm/screens/worm.dart';

class Wall extends RectangleComponent
  with Collidable, HasGameRef<GameLoop> {
  Wall(size, position) : super(size: size, position: position);
  var dy = 2;

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Worm) {
      gameRef.gameLoopState.gameOver();
    }
  }

  @override
  void update(double dt) {
    position = Vector2(x + 0.0, y + dy);
    if (position.y > 1000){
      gameRef.remove(this);
    }
  }
}