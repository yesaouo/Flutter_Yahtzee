import 'package:flutter/material.dart';
import 'package:hw3_yahtzee/anime.dart';
import 'package:hw3_yahtzee/data.dart';
import 'package:hw3_yahtzee/gamebar.dart';
import 'package:hw3_yahtzee/playground.dart';
import 'package:hw3_yahtzee/scoreboard.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 39, 104)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  YahtzeeGame game = YahtzeeGame();
  void alertGameRestart() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Restart'),
        content: const Text('Restart the game?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                game.init();
                game.page = true;
              });
              Navigator.pop(context, 'OK');
              showYahtzee();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void alertGameEnd() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(game.getWinner() == 0
            ? 'Draw!'
            : 'Player ${game.getWinner()} Win!'),
        content: const Text('Restart the game?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                game.init();
                game.page = true;
              });
              Navigator.pop(context, 'OK');
              showYahtzee();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void alertAIExecution() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AI in Execution'),
        content: const Text('Cannot click this button while AI is executing'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> aiMove() async {
    game.isAI = true;
    if (game.dice.remainTime == 3) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => game.dice.roll());
    }
    if (game.dice.suggestRoll()) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => game.dice.aiLock());
      await Future.delayed(const Duration(seconds: 1));
      setState(() => game.dice.roll());
    }
    if (game.dice.suggestRoll()) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => game.dice.aiLock());
      await Future.delayed(const Duration(seconds: 1));
      setState(() => game.dice.roll());
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() => game.setScore(game.suggestChoice()));
    game.isAI = false;
    if (!game.nextTurn()) {
      alertGameEnd();
    }
  }

  Future<void> showYahtzee() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const YahtzeeAnime()));
    await Future.delayed(const Duration(seconds: 3));
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  bool canRun() {
    if (game.isAI) {
      alertAIExecution();
      return false;
    }
    return true;
  }

  void updateLock(int key) {
    if (canRun()) {
      setState(() => game.dice.toggleLock(key));
    }
  }

  void updateTime() {
    if (canRun()) {
      setState(() => game.dice.roll());
      if (game.haveYahtzee()) {
        showYahtzee();
      }
    }
  }

  void updateScore(int key) {
    if (canRun()) {
      setState(() {
        game.setScore(key);
        if (game.nextTurn()) {
          if (game.canAIMove()) {
            aiMove();
          }
        } else {
          alertGameEnd();
        }
      });
    }
  }

  void togglePage() {
    setState(() => game.togglePage());
  }

  void toggleVolume() {
    setAudioPlayer();
  }

  void toggleAI() {
    if (canRun()) {
      setState(() => game.toggleAI());
      if (game.canAIMove()) {
        aiMove();
      }
    }
  }

  void initGame() {
    if (canRun()) {
      alertGameRestart();
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> setAudioPlayer() async {
    if (game.volume) {
      _audioPlayer.pause();
      setState(() => game.volume = false);
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('01_Main_Menu.mp3'));
      setState(() => game.volume = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 111, 81),
      body: Center(
        child: Row(
          children: [
            ScoreboardTile(
              isP1: game.isP1,
              diceScore: game.dice.score,
              p1Score: game.player1.words,
              p2Score: game.player2.words,
              updateScore: updateScore,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GamebarTile(
                    page: game.page,
                    volume: game.volume,
                    ai: game.ai,
                    p1Point: game.player1.getTotal(),
                    p2Point: game.player2.getTotal(),
                    diceTime: game.dice.remainTime,
                    updateTime: updateTime,
                    togglePage: togglePage,
                    toggleVolume: toggleVolume,
                    toggleAI: toggleAI,
                    initGame: initGame,
                  ),
                  Expanded(
                    child: PlaygroundTile(
                      isP1: game.isP1,
                      dice: game.dice.dice,
                      lock: game.dice.lock,
                      updateLock: updateLock,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
