import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects/utils/constants.dart';

class AddConsultationPageWidget extends StatefulWidget {
  const AddConsultationPageWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AddConsultationPageWidgetState();
}

class _AddConsultationPageWidgetState extends State<AddConsultationPageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  bool contentVisible = false;
  Timer? timer;
  Animatable<Color?> background = TweenSequence<Color?>(
    [
      TweenSequenceItem(
          weight: 0.5,
          tween: ColorTween(
            begin: const Color(0xff0055FF),
            end: Colors.grey,
          )),
      TweenSequenceItem(
          weight: 0.5,
          tween: ColorTween(
            begin: Colors.grey,
            end: Colors.grey,
          ))
    ],
  );

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: Constants.standardAnimationDuration),
        (Timer t) {
      setState(() {
        contentVisible = !contentVisible;
        triggerBgChangeAnimation();
      });
      timer?.cancel();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void triggerBgChangeAnimation() async {
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: _buildCrossIconFAB(context),
            backgroundColor:
                background.evaluate(AlwaysStoppedAnimation(_controller.value)),
            body: WillPopScope(
              onWillPop: () async {
                onClosePage();
                return false;
              },
              child: AnimatedOpacity(
                opacity: contentVisible ? 1.0 : 0.0,
                duration: const Duration(
                    milliseconds: Constants.fabCrossIconAnimationDuration),
                child: const SizedBox(
                  child: null,
                ),
              ),
            ),
          );
        });
  }

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.1),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));

  bool crossIconVisible = false;

  void onClosePage() {
    setState(() {
      //contentVisible = !contentVisible;
    });
    Navigator.pop(context, true);
  }

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0.75,
  );

  Widget _buildCrossIconFAB(context, {key}) => SlideTransition(
        position: _offsetAnimation,
        child: AnimatedSlide(
          duration: const Duration(
              milliseconds: Constants.fabCrossIconAnimationDuration),
          offset: contentVisible ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            key: key,
            duration: const Duration(
                milliseconds:
                    Constants.consultationListPageScreenTransitionDuration),
            opacity: crossIconVisible ? 0.0 : 1.0,
            child: Padding(
              padding: Constants.fabPadding,
              child: RotationTransition(
                turns: turnsTween.animate(_controller),
                child: SizedBox(
                  width: Constants.fabButtonSize,
                  height: Constants.fabButtonSize,
                  child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        onClosePage();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
        ),
      );
}
