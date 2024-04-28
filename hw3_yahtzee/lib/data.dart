import 'dart:math';

class Dice {
  int remainTime = 3;
  List<int> dice = List.filled(5, 0);
  List<bool> lock = List.filled(5, false);
  List<int> score = List.filled(14, 0);

  void init() {
    remainTime = 3;
    dice = List.filled(5, 0);
    lock = List.filled(5, false);
    score = List.filled(14, 0);
  }

  void roll() {
    if (remainTime > 0) {
      for (int i = 0; i < 5; i++) {
        if (!lock[i]) {
          dice[i] = Random().nextInt(6) + 1;
        }
      }
      remainTime--;
    }
    setScore();
  }

  void setScore() {
    score = List.filled(14, 0);
    List<int> counts = getCounts();

    // Calculate scores for single number categories
    for (int i = 1; i <= 6; i++) {
      score[i - 1] = counts[i] * i;
    }

    // Calculate scores for three/four of a kind, full house, and yahtzee
    bool hasPair = false;
    bool hasThreeOfAKind = false;

    for (int count in counts) {
      if (count >= 3) {
        score[7] = dice.reduce((a, b) => a + b); // Three of a kind
        hasThreeOfAKind = true;
        if (count >= 4) {
          score[8] = dice.reduce((a, b) => a + b); // Four of a kind
          if (count == 5) {
            score[12] = 50; // Yahtzee
          }
        }
      }
      if (count == 2) {
        hasPair = true;
      }
    }

    if (hasPair && hasThreeOfAKind) {
      score[9] = 25; // Full house
    }

    // Calculate scores for small and large straight
    if (counts.sublist(1, 5).every((count) => count >= 1) ||
        counts.sublist(2, 6).every((count) => count >= 1) ||
        counts.sublist(3, 7).every((count) => count >= 1)) {
      score[10] = 30; // Small straight
    }
    if (counts.sublist(1, 6).every((count) => count >= 1) ||
        counts.sublist(2, 7).every((count) => count >= 1)) {
      score[11] = 40; // Large straight
    }

    // Calculate score for chance
    score[13] = dice.reduce((a, b) => a + b);
  }

  void toggleLock(int key) {
    if (dice[key] != 0) {
      lock[key] = !lock[key];
    }
  }

  List<int> getCounts() {
    List<int> counts = List.filled(7, 0);
    for (int die in dice) {
      counts[die]++;
    }
    return counts;
  }
}

class Score {
  List<int?> score = List.filled(14, null);
  List<String> words = List.generate(14, (index) => index != 6 ? '' : '0');
  static List<String> imgNames = [
    'dice1',
    'dice2',
    'dice3',
    'dice4',
    'dice5',
    'dice6',
    'bonus',
    'three',
    'four',
    'home',
    'minimize',
    'maximize',
    'motor-powered-boat',
    'question-sign'
  ];

  void init() {
    score = List.filled(14, null);
    words = List.generate(14, (index) => index != 6 ? '' : '0');
  }

  void setScore(int key, int value) {
    score[key] = value;
    words[key] = value.toString();
    setBonus();
  }

  void setBonus() {
    int sum = 0;
    for (int i = 0; i < 6; i++) {
      sum += score[i] ?? 0;
    }
    if (sum >= 63) {
      score[6] = 35;
      words[6] = '35';
    }
  }

  int getTotal() {
    int total = 0;
    for (int i = 0; i < score.length; i++) {
      total += score[i] ?? 0;
    }
    return total;
  }
}

class YahtzeeGame {
  Score player1 = Score();
  Score player2 = Score();
  Dice dice = Dice();
  bool ai = true;
  bool isAI = false;
  bool isP1 = true;
  bool page = true;
  bool volume = false;
  int round = 1;

  void init() {
    round = 1;
    isP1 = true;
    dice.init();
    player1.init();
    player2.init();
  }

  void togglePage() {
    page = !page;
  }

  void toggleVolume() {
    volume = !volume;
  }

  void toggleAI() {
    ai = !ai;
  }

  bool canAIMove() {
    return (ai && !isP1 && round < 14 && dice.remainTime > 0);
  }

  bool setScore(int key) {
    if (isP1 && player1.score[key] == null) {
      player1.setScore(key, dice.score[key]);
      return true;
    } else if (!isP1 && player2.score[key] == null) {
      player2.setScore(key, dice.score[key]);
      return true;
    }
    return false;
  }

  bool nextTurn() {
    isP1 = !isP1;
    if (isP1) {
      round++;
    }
    if (round == 14) {
      isP1 = false;
      return false;
    }
    dice.init();
    return true;
  }

  int getWinner() {
    int sum1 = player1.getTotal();
    int sum2 = player2.getTotal();
    if (sum1 > sum2) {
      return 1;
    }
    if (sum1 < sum2) {
      return 2;
    }
    return 0;
  }

  int findMostFrequent() {
    List<int> counts = dice.getCounts();
    List<int?> score = isP1 ? player1.score : player2.score;
    while (true) {
      int maxCount = counts.reduce(max);
      if (maxCount == 0) {
        return -1;
      }
      int mostFrequent = counts.indexOf(maxCount);
      if (score[mostFrequent - 1] == null) {
        return mostFrequent - 1;
      }
      counts[mostFrequent] = 0;
    }
  }

  int suggestChoice() {
    List<int?> score = isP1 ? player1.score : player2.score;
    int maxScore = 0;
    int bestMove = -1;

    for (int i = 7; i < 13; i++) {
      if (score[i] == null && dice.score[i] > maxScore) {
        maxScore = dice.score[i];
        bestMove = i;
      }
    }

    if (bestMove == -1) {
      bestMove = findMostFrequent();
    }

    if (bestMove == -1) {
      for (int i = 7; i < 14; i++) {
        if (score[i] == null) {
          bestMove = i;
        }
      }
    }

    return bestMove;
  }
}
