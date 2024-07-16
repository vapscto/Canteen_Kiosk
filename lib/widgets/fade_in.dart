import 'package:flutter/material.dart';

enum FadeInDirection { ttb, btt, ltr, rtl }

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation(
      {super.key,
        required this.child,
        required this.delay,
        required this.direction,
        required this.fadeOffset});

  final Widget child;
  final double delay;
  final double fadeOffset;
  final FadeInDirection direction;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> inAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: (500 * widget.delay).round()),
        vsync: this);
    inAnimation =
    Tween<double>(begin: -widget.fadeOffset, end: 0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    Offset offset;
    switch (widget.direction) {
      case FadeInDirection.ltr:
        offset = Offset(inAnimation.value, 0);
        break;
      case FadeInDirection.rtl:
        offset = Offset(-inAnimation.value, 0);
        break;
      case FadeInDirection.ttb:
        offset = Offset(0, inAnimation.value);
        break;
      case FadeInDirection.btt:
        offset = Offset(0, -inAnimation.value);
        break;
    }

    return Transform.translate(
      offset: offset,
      child: Opacity(
        opacity: opacityAnimation.value,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
