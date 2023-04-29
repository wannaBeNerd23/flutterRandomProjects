import 'package:flutter/material.dart';

class ConsultationListWidget extends StatelessWidget {
  const ConsultationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 180, left: 90),
        child: showDummyCards(context),
      ),
    );
  }

  Widget showDummyCards(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset('assets/pages/consultation_list_item.png');
        });
  }
}
