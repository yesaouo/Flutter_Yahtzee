import 'package:flutter/material.dart';

class GamebarTile extends StatelessWidget {
  const GamebarTile({
    super.key,
    required this.page,
    required this.volume,
    required this.ai,
    required this.p1Point,
    required this.p2Point,
    required this.diceTime,
    required this.updateTime,
    required this.togglePage,
    required this.toggleVolume,
    required this.toggleAI,
    required this.initGame,
  });
  final bool ai;
  final bool page;
  final bool volume;
  final int p1Point;
  final int p2Point;
  final int diceTime;
  final void Function() updateTime;
  final void Function() togglePage;
  final void Function() toggleVolume;
  final void Function() toggleAI;
  final void Function() initGame;

  List<Widget> pageWidgets() {
    if (page) {
      return [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Player 1', style: TextStyle(color: Colors.white)),
            Text(p1Point.toString(),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        GestureDetector(
          onTap: updateTime,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.asset('assets/gamebar/dice-cube.png', width: 50),
              Text(diceTime.toString()),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Player 2', style: TextStyle(color: Colors.white)),
            Text(p2Point.toString(),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(volume ? Icons.volume_up : Icons.volume_off),
          onPressed: toggleVolume,
        ),
        IconButton(
          icon: Icon(ai ? Icons.smart_toy_outlined : Icons.person),
          onPressed: toggleAI,
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: initGame,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: const Color.fromARGB(255, 80, 121, 178),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: pageWidgets(),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                height: 56,
                child: VerticalDivider(color: Colors.white),
              ),
              IconButton(
                icon: Icon(page ? Icons.menu : Icons.arrow_forward,
                    color: Colors.white),
                onPressed: togglePage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
