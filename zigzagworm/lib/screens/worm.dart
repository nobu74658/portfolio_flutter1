import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:zigzagworm/screens/game.dart';

class Worm extends CircleComponent with Collidable, HasGameRef<GameLoop>, KeyboardHandler {
  final _dx = 3;
  var _isGoRight = false;
  int _accelerator = 1;
  bool _isChangeDirection;

  Worm(radius, position, num, this._isChangeDirection,) : super(radius: radius, position: position);

  @override
  void update(double dt) {
      if (_isGoRight && !_isChangeDirection){
          _isGoRight = false;
          _accelerator = 1;
      }
      if (!_isGoRight && _isChangeDirection) {
          _isGoRight = true;
          _accelerator = 1;
      }

      if (_isGoRight) {
        x += _dx + _accelerator * 0;
        _accelerator++;
      }
      if (!_isGoRight) {
        x -= _dx + _accelerator * 0;
        _accelerator++;
      }
  }
}

