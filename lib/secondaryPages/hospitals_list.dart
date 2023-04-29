
import 'package:flutter/material.dart';

class HospitalsListWidget extends StatelessWidget {
  const HospitalsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 120, left: 30),
        child: Image.asset('assets/pages/home.png'),
      ),
    );
  }
}
