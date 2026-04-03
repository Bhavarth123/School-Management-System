import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPress;

  const Bouncing({
    Key? key,
    required this.child,
    this.onPress,
  }) : super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1 - _controller.value;

    return Listener(
      onPointerDown: (_) {
        if (widget.onPress != null) {
          _controller.forward();
        }
      },
      onPointerUp: (_) {
        if (widget.onPress != null) {
          _controller.reverse();
          widget.onPress!();
        }
      },
      child: Transform.scale(
        scale: scale,
        child: widget.child,
      ),
    );
  }
}
