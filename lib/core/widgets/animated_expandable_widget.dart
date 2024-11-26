import 'package:flutter/material.dart';

import 'divider_heading.dart';

class AnimatedExpandableWidget extends StatefulWidget {
  const AnimatedExpandableWidget({
    super.key,
    required this.isExpanded,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  final bool isExpanded;
  final Widget child;
  final Duration duration;

  @override
  _AnimatedExpandableWidgetState createState() => _AnimatedExpandableWidgetState();
}

class _AnimatedExpandableWidgetState extends State<AnimatedExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExpandableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DividerHeading(
          heading: "Addition Outlet Info",
          onToggle: (value) {
            if(value){
              _controller.forward();
            }else{
              _controller.reverse();
            }
          },
        ),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0, // Aligns at the top during expansion
          child: widget.child,
        ),
      ],
    );
  }
}
