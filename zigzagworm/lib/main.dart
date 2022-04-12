import 'package:flutter/material.dart';
import 'package:zigzagworm/screens/game.dart';

//以下のサイト・アプリを参考にさせていただきました。
//https://qiita.com/kawamou/items/dc940961186c1c2f1571
//https://apps.apple.com/jp/app/scrolling-snake-crazy-game/id1084096344?l=en

void main() {
  runApp(
      MaterialApp(
        home: GameLoopWidget(),
      )
  );
}