import 'package:flutter/material.dart';

class SmallDiceTile extends StatelessWidget {
  const SmallDiceTile({
    super.key,
    required this.dice,
    this.onPressed,
  });
  final int dice;
  final void Function()? onPressed;

  Image getImage() {
    if (dice == 0) {
      return Image.asset(
        'assets/playground/rounded-square.png',
        color: onPressed != null ? Colors.green : null,
        width: 65,
      );
    } else {
      return Image.asset(
        'assets/playground/dice$dice.png',
        width: 65,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2.5),
        child: getImage(),
      ),
    );
  }
}

class BigDiceTile extends StatelessWidget {
  const BigDiceTile({super.key, required this.dice});
  final int dice;

  Image getImage() {
    if (dice == 0) {
      return Image.asset(
        'assets/playground/rounded-square.png',
        width: 90,
      );
    } else {
      return Image.asset(
        'assets/playground/dice$dice.png',
        width: 90,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: getImage(),
    );
  }
}

class PlayerDiceTile extends StatelessWidget {
  const PlayerDiceTile({super.key, required this.smallDices});
  final List<Widget> smallDices;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: smallDices,
    );
  }
}

class TableDiceTile extends StatelessWidget {
  const TableDiceTile({super.key, required this.bigDices});
  final List<Widget> bigDices;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bigDices,
    );
  }
}

class PlaygroundTile extends StatelessWidget {
  const PlaygroundTile({
    super.key,
    required this.isP1,
    required this.dice,
    required this.lock,
    required this.updateLock,
  });
  final bool isP1;
  final List<int> dice;
  final List<bool> lock;
  final void Function(int) updateLock;

  List<Widget> getSmallDices(bool isTurn) {
    return isTurn
        ? List.generate(
            5,
            (index) => SmallDiceTile(
              dice: lock[index] ? dice[index] : 0,
              onPressed: dice[index] != 0 ? () => updateLock(index) : null,
            ),
          )
        : List.filled(
            5,
            const SmallDiceTile(dice: 0),
          );
  }

  List<Widget> getBigDices() {
    return List.generate(
      5,
      (index) => BigDiceTile(
        dice: lock[index] ? 0 : dice[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlayerDiceTile(
          smallDices: getSmallDices(isP1 == false),
        ),
        TableDiceTile(
          bigDices: getBigDices(),
        ),
        PlayerDiceTile(
          smallDices: getSmallDices(isP1 == true),
        ),
      ],
    );
  }
}
