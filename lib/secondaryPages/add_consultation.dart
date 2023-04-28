import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects/utils/constants.dart';

class AddConsultationPageWidget extends StatefulWidget {
  const AddConsultationPageWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AddConsultationPageWidgetState();
}

class _AddConsultationPageWidgetState extends State<AddConsultationPageWidget> {
  bool contentVisible = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: Constants.animationDuration), (Timer t) {
      setState(() {
        contentVisible = !contentVisible;
      });
      timer?.cancel();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0055FF),
      body: AnimatedOpacity(
        opacity: contentVisible ? 1.0 : 0.0,
        duration:
            const Duration(milliseconds: Constants.animationDuration - 300),
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              setState(() {
                contentVisible = !contentVisible;
              });
              Navigator.pop(context, true);
            },
            child: const Text(
              'Go back!',
              style: TextStyle(color: Color(0xff0055FF)),
            ),
          ),
        ),
      ),
    );
  }
}
