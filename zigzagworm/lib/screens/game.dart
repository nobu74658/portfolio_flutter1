import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:zigzagworm/screens/gameover_view.dart';
import 'package:zigzagworm/screens/initial_view.dart';
import 'package:zigzagworm/screens/outerwall.dart';
import 'package:zigzagworm/screens/score_wall.dart';
import 'package:zigzagworm/screens/worm.dart';
import 'package:zigzagworm/screens/worm_body.dart';
import 'package:zigzagworm/screens/wall.dart';

class GameLoopWidget extends StatefulWidget {
  GameLoopWidget({Key? key}) : super(key: key);

  @override
  State<GameLoopWidget> createState() => _GameLoopWidgetState();
}

class _GameLoopWidgetState extends State<GameLoopWidget> {
  final gameLoop = GameLoop(GameLoopState(0, false, false));

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        height: deviceHeight * 0.9,
        width: deviceWidth * 0.9,
        child: GameWidget(
          game: gameLoop,
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          overlayBuilderMap: {
            'initial': (context, GameLoop gameLoop) => InitialView(
              gameLoop: gameLoop,
            ),
            'gameover': (context, GameLoop gameLoop) => GameOverView(
                gameLoop: gameLoop
            ),
          },
          initialActiveOverlays: const ['initial'],
        ),
      ),
    );
  }
}

class GameLoop extends FlameGame
  with HasCollidables, HasKeyboardHandlerComponents, TapDetector {
  static const wallColCount = 6;
  final GameLoopState gameLoopState;
  bool _isChangeDirection = false;
  bool _isTapDown = false;

  GameLoop(this.gameLoopState) : super();

  @override
  bool onTapDown(TapDownInfo event) {
    if(!gameLoopState.isGameOver){
      _isTapDown = true;
    }
      return true;
  }

  void onOverlayChanged() {
    if (overlays.isActive('initial')) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    if (gameLoopState.isGameOver) {
      var allWalls = children.query<Wall>();
      var snake = children.query<Worm>();
      var snakeBody = children.query<WormBody>();
      var outerWalls = children.query<OuterWall>();
      var scoreWalls = children.query<ScoreWall>();
      var scoreBoard = children.query<TextComponent>();
      removeAll(allWalls);
      removeAll(snake);
      removeAll(snakeBody);
      removeAll(outerWalls);
      removeAll(scoreWalls);
      removeAll(scoreBoard);
      gameLoopState.BestScore();
      overlays.add('gameover');
    }
    if (gameLoopState.isMoreWall){
      addMoreWall();
      gameLoopState.isMoreWall = false;
      var scoreBoard = children.query<TextComponent>();
      removeAll(scoreBoard);
      addScoreBoard();
    }
    if (_isTapDown){
      var worm = children.query<Worm>();
      var wormBody = children.query<WormBody>();
      var wormLength = wormBody.length;
      const wormRadius = 12.0;
      _isChangeDirection? _isChangeDirection = false : _isChangeDirection = true;
      var wormX = worm.first.position.x;
      var wormY = canvasSize.y * 0.7 + wormRadius;
      removeAll(worm);
      add(Worm(wormRadius,
          Vector2(wormX, wormY),-1, _isChangeDirection));
      for (var i = 0; i < wormLength; i++){
        gameLoopState.wormChangeDirectionState[i].add(true);
      }
      _isTapDown = false;
    }
    super.update(dt);
  }

  void reload() {
    addInitialWall();
    addInitialOuterWall();
    gameLoopState.reset();
    _isChangeDirection = false;
    addInitialWorm();
    addScoreBoard();
  }

  void addInitialOuterWall() {
    const outerWallWidth = 2.0;
    final outerWallHeight = canvasSize.y;
    const _correctWidth = 17.0;
    var outerWallPositionY = 0.0;
    var outerWallPositionX =  - _correctWidth + outerWallWidth ;
    add(OuterWall(Vector2(outerWallWidth, outerWallHeight),
        Vector2(outerWallPositionX, outerWallPositionY)));
    outerWallPositionX = canvasSize.x + _correctWidth - outerWallWidth - 2.0 ;
    add(OuterWall(Vector2(outerWallWidth, outerWallHeight),
        Vector2(outerWallPositionX, outerWallPositionY)));

  }

  void addInitialWall() {
    final wallWidth = canvasSize.x / wallColCount;
    const wallHeight = 2.0;
    var random = Random();
    Paint scoreWallPaint = Paint();
    scoreWallPaint.color = const Color(0x00000000);
    List<int> wallExist = [];
    for (var n = 0; n < wallColCount + 1; n++) {
      wallExist.add(1);
    }
    for (var i = 0; i < 2; i++) {
      wallExist[random.nextInt(wallExist.length)] = 0;
      var wallPositionY = - canvasSize.y * 0.1 + canvasSize.y * 0.5 * i;
      for (var j = 0; j < wallColCount +1; j++) {
        var wallPositionX = (canvasSize.x / (wallColCount) * j) - wallWidth / 2;
        if (wallExist[j] == 1) {
          add(Wall(Vector2(wallWidth, wallHeight),
          Vector2(wallPositionX, wallPositionY)));
        } else {
          add(ScoreWall(Vector2(wallWidth, wallHeight),
          Vector2(wallPositionX, wallPositionY),scoreWallPaint ));
          wallExist[j] = 1;
        }
      }
    }
  }

  void addMoreWall() {
    final wallWidth = canvasSize.x / wallColCount;
    const wallHeight = 2.0;
    const initialWallState = 200.0;
    Paint scoreWallPaint = Paint();
    scoreWallPaint.color = const Color(0x00000000);
    var random = Random();
    List<int> wallExist = [];
    for (var n = 0; n < wallColCount + 1; n++) {
      wallExist.add(1);
    }
    wallExist[random.nextInt(wallExist.length)] = 0;
    var wallPositionY = canvasSize.y * 0.1 - initialWallState;
    for (var i = 0; i < wallColCount +1; i++) {
      var wallPositionX = (canvasSize.x / (wallColCount) * i) - wallWidth / 2;
      if (wallExist[i] == 1) {
        add(Wall(Vector2(wallWidth, wallHeight),
            Vector2(wallPositionX, wallPositionY)));
      } else {
        add(ScoreWall(Vector2(wallWidth, wallHeight),
            Vector2(wallPositionX, wallPositionY),scoreWallPaint ));
            wallExist[i] = 1;
      }


    }
  }

  void addInitialWorm() {
    var wormRadius = 12.0;
    final wormX = (canvasSize.x - wormRadius) / 2;
    final wormLength = gameLoopState.wormLength;
    var wormY = canvasSize.y * 0.7 + wormRadius;
    for (var i = 0; i < wormLength; i++){
      gameLoopState.wormChangeDirectionState.add([true]);
    }
    add(Worm(wormRadius,
    Vector2(wormX, wormY),-1, false));
    wormRadius = 10.0;
    for (var i = 0; i < wormLength; i++) {
      wormY = canvasSize.y * 0.7 + wormRadius * (i+2);
      add(WormBody(wormRadius,
      Vector2(wormX, wormY),i));
    }
  }

  void addScoreBoard() {
    add(TextComponent(text:(gameLoopState.score == -1)? ('0') : '${gameLoopState.score}',textRenderer: TextPaint(style: const TextStyle(fontSize: 30.0)))
      ..anchor = Anchor.topCenter
      ..x = canvasSize.x / 2
      ..y = canvasSize.y * 0.15);
  }

  @override
  void onMount() {
    paused = true;
    overlays.addListener(onOverlayChanged);
    super.onMount();
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(ScreenCollidable());
    addInitialWall();
    addInitialWorm();
    addScoreBoard();
    addInitialOuterWall();
    addScoreBoard();
    children.register<Wall>();
    children.register<Worm>();
    children.register<WormBody>();
    children.register<OuterWall>();
    children.register<ScoreWall>();
    children.register<TextComponent>();
  }
}

class GameLoopState {
  int score;
  int bestScore = 0;
  final wormLength = 10;
  bool isGameOver;
  bool isMoreWall;
  List<List<bool>> wormChangeDirectionState =[];

  GameLoopState(this.score, this.isGameOver, this.isMoreWall);

  void reset() {
    score = 0;
    isGameOver = false;
    isMoreWall = false;
    wormChangeDirectionState = [];
  }

  void incrementScore() {
    score ++;
    isMoreWall = true;
  }

  void gameOver() {
    isGameOver = true;
  }

  void BestScore() {
    if (bestScore < score) {
      bestScore = score;
    }
  }
}