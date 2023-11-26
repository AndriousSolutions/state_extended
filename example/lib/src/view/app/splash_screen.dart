//
import 'package:flutter/material.dart';

/// A very simple Splash screen
class SplashScreen extends StatelessWidget {
  ///
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const OverflowBox(
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image(image: AssetImage('assets/images/meow.gif')),
        ),
      );
}
