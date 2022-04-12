import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:zigzagworm/screens/game.dart';

class WormBody extends CircleComponent with Collidable, HasGameRef<GameLoop>, KeyboardHandler {
  final _dx = 3;
  var _isGoRight = true;
  int _accelerator = 1;
  bool _isDoneFirstMove = false;
  bool _isLoading = false;
  int num;

  WormBody(radius, position, this.num) : super(radius: radius, position: position);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
  }

  @override
  void update(double dt) async {
      if(!_isLoading){
          _isLoading = true;
      if (gameRef.gameLoopState.wormChangeDirectionState[num].isNotEmpty){
          await Future.delayed(Duration(milliseconds: (num+1) * 50));
          _isGoRight? _isGoRight = false: _isGoRight = true;
          gameRef.gameLoopState.wormChangeDirectionState[num].removeLast();
          _accelerator = 1;
          _isDoneFirstMove = true;
      }
          _isLoading = false;
          _isDoneFirstMove = true;
      }

      if (_isDoneFirstMove){
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
}

