import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FullScreenImage()));

            await Future.delayed(Duration(seconds: 3));

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Text('Show Image'),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
