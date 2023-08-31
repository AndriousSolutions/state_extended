//
import 'package:flutter/material.dart';

/// A very simple Splash screen
class SplashScreen extends StatelessWidget {
  ///
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => OverflowBox(
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Container(
          width: 100,
          height: 100,
          child: const Image(image: AssetImage('assets/images/meow.gif')),
        ),
      );
}
