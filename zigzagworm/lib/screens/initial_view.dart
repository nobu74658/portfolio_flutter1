import 'package:flutter/material.dart';
import 'package:zigzagworm/screens/game.dart';

class InitialView extends StatelessWidget {
  const InitialView({Key? key, required this.gameLoop}) : super(key: key);
  
  final GameLoop gameLoop;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: const [
            SizedBox(height: 100.0,),
            Text('ZIGZAG WORM',style: TextStyle(fontSize: 30.0,decoration: TextDecoration.none,color: Colors.white),),
            SizedBox(height: 500.0,),
            Text('TOUCH TO START',style: TextStyle(fontSize: 14.0,decoration: TextDecoration.none,color: Colors.white),),
          ],
        ),
        onTap: () => {
          gameLoop.overlays.remove('initial'),
        }
      ),
    );
  }
}