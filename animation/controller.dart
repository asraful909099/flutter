import 'package:flutter/material.dart';

class AnimationControllTools {
  late AnimationController _animationController;
  late Animation<double> _animatedValue;
  late Animation<double> _curve;
  late Curve? curvesType;
  late double? begin;
  late double? end;
  late bool tweenSequence = false;
  late List<double>? animationSequence;
  late List<double>? animationWeight;
  final TickerProvider controlHouse;
  AnimationControllTools(
      {required this.controlHouse,
      required Duration duration,
      this.begin,
      this.end,
      this.curvesType,
      this.animationSequence,
      this.animationWeight,
      this.tweenSequence = false}) {
    _animationController =
        AnimationController(vsync: controlHouse, duration: duration);
    tweenSequence == false ? animationInit() : sequence();
  }
  void animationInit() {
    _curve = CurvedAnimation(parent: _animationController, curve: curvesType!);
    _animatedValue = Tween(begin: begin, end: end).animate(_curve);
  }

  void start() {
    _animationController.forward();
  }

  void animationUpdate({required double begin, required double end}) {
    if (begin != end) {
      _animationController.reset();
      _animatedValue = Tween(begin: begin, end: end).animate(_curve);
      _animationController.forward();
    }
  }

  void animationReuse() {
    _animationController.reset();
    _animationController.forward();
  }

  void sequence() {
    List<TweenSequenceItem<double>> animationList = _getAnimationSequence();
    final curves =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animatedValue =
        TweenSequence<double>(<TweenSequenceItem<double>>[...animationList])
            .animate(curves);
  }

  List<TweenSequenceItem<double>> _getAnimationSequence() {
    late List<TweenSequenceItem<double>> build = [];
    for (var i = 0; i < animationSequence!.length - 1; i++) {
      build.insert(
      i,
      TweenSequenceItem<double>(
          tween: Tween<double>(
              begin: animationSequence![i], end: animationSequence![i + 1]),
          weight: animationWeight![i]));
    }
    return build;
  }



  void close() {
    _animationController.dispose();
  }

  double get value => _animatedValue.value;
  AnimationController get control => _animationController;
}
