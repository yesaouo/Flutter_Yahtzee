import 'package:flutter/material.dart';

class YahtzeeAnime extends StatelessWidget {
  const YahtzeeAnime({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            'assets/speedboat.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
