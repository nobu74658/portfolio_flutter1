import 'package:flutter/material.dart';
import 'package:zigzagworm/screens/game.dart';

class GameOverView extends StatelessWidget {
  const GameOverView({Key? key, required this.gameLoop}) : super(key: key);

  final GameLoop gameLoop;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100.0,),
          Text((gameLoop.gameLoopState.score == -1)? '0' :'${gameLoop.gameLoopState.score.toInt()}',
          style: const TextStyle(
            fontSize: 30.0,
            decoration: TextDecoration.none,
            color: Colors.white,
          ),),
          const SizedBox(height: 60.0,),
          const Text('BEST',
          style: TextStyle(
            fontSize: 16.0,
            decoration: TextDecoration.none,
            color: Colors.white,
          ),),
          Text('${gameLoop.gameLoopState.bestScore}',
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),),
          const SizedBox(height: 300.0,),
          GestureDetector(
              child: const Icon(Icons.arrow_right_rounded,size: 160.0,color: Colors.white,),
              onTap: () {
                gameLoop.reload();
                gameLoop.overlays.remove('gameover');
              },),
        ],
      ),
    );
  }
}
