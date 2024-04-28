import 'package:flutter/material.dart';
import 'package:hw3_yahtzee/data.dart';

class ScoreboardTile extends StatelessWidget {
  const ScoreboardTile({
    super.key,
    required this.isP1,
    required this.diceScore,
    required this.p1Score,
    required this.p2Score,
    required this.updateScore,
  });
  final bool isP1;
  final List<int> diceScore;
  final List<String> p1Score;
  final List<String> p2Score;
  final void Function(int key) updateScore;

  List<Widget> getColumnElements() {
    bool canScored(bool check, int index) {
      return (check && isP1 && p1Score[index] == '') ||
          (!check && !isP1 && p2Score[index] == '');
    }

    List<Image> scoreImage = List.generate(
      Score.imgNames.length,
      (index) => Image.asset(
        'assets/scoreboard/${Score.imgNames[index]}.png',
        width: 44,
        height: 44,
      ),
    );
    List<Text> p1ScoreText = List.generate(p1Score.length, (index) {
      if (canScored(true, index)) {
        return Text(diceScore[index].toString());
      }
      return Text(p1Score[index]);
    });
    List<Text> p2ScoreText = List.generate(p2Score.length, (index) {
      if (canScored(false, index)) {
        return Text(diceScore[index].toString());
      }
      return Text(p2Score[index]);
    });

    List<Widget> rows = [];
    for (int i = 0; i < 7; i++) {
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ScoreboardImg(img: scoreImage[i]),
                ScoreboardVal(
                  val: p1ScoreText[i],
                  onPressed: canScored(true, i) ? () => updateScore(i) : null,
                ),
                ScoreboardVal(
                  val: p2ScoreText[i],
                  onPressed: canScored(false, i) ? () => updateScore(i) : null,
                ),
              ],
            ),
            Row(
              children: [
                ScoreboardImg(img: scoreImage[i + 7]),
                ScoreboardVal(
                  val: p1ScoreText[i + 7],
                  onPressed:
                      canScored(true, i + 7) ? () => updateScore(i + 7) : null,
                ),
                ScoreboardVal(
                  val: p2ScoreText[i + 7],
                  onPressed:
                      canScored(false, i + 7) ? () => updateScore(i + 7) : null,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(
            width: 4.0, color: const Color.fromARGB(255, 7, 39, 104)),
        color: const Color.fromARGB(255, 247, 239, 232),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: getColumnElements(),
      ),
    );
  }
}

class ScoreboardVal extends StatelessWidget {
  const ScoreboardVal({
    super.key,
    required this.val,
    required this.onPressed,
  });

  final Text val;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 32,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 7, 39, 104)),
          color: onPressed != null ? Colors.green : null,
        ),
        child: Center(child: val),
      ),
    );
  }
}

class ScoreboardImg extends StatelessWidget {
  const ScoreboardImg({
    super.key,
    required this.img,
  });

  final Image img;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 7, 39, 104)),
      ),
      child: Center(child: img),
    );
  }
}
