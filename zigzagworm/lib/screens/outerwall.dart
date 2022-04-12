import 'package:flame/components.dart';
import 'package:zigzagworm/screens/game.dart';
import 'package:zigzagworm/screens/worm.dart';

class OuterWall extends RectangleComponent
  with Collidable, HasGameRef<GameLoop> {
  OuterWall(size, position) : super(size: size, position: position);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Worm) {
      gameRef.gameLoopState.gameOver();
    }
  }
}