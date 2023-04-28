import 'package:flutter/material.dart';

class ConsultationListWidget extends StatelessWidget {
  const ConsultationListWidget({super.key});

  static List<String> dataItems = [
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test",
    "string",
    "test"
  ];

  @override
  Widget build(BuildContext context) {
    var borderRadius = const BorderRadius.only(
        topRight: Radius.circular(32), bottomRight: Radius.circular(32));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 128,
          top: 136,
          right: 30,
          bottom: 0,
        ),
        child: ListView.builder(
          itemCount: dataItems.length,
          prototypeItem: ListTile(
            title: Text(dataItems.first),
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                tileColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                title: Text(dataItems[index], style: const TextStyle(
                  color: Colors.white, fontSize: 16
                ),),
              ),
            );
          },
        ),
      ),
    );
  }
}
