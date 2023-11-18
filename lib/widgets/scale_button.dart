import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  bool isOutsideOf(RenderBox box) {
    final boxSize = box.size;
    final boxPosition = box.localToGlobal(Offset.zero);

    return dx < boxPosition.dx || dx > boxPosition.dx + boxSize.width || dy < boxPosition.dy || dy > boxPosition.dy + boxSize.height;
  }
}

class ScaleButton extends StatefulWidget {
  final Function()? onPressed;
  final Widget child;
  final Duration scaleDuration;
  final double scaleFactor;

  const ScaleButton({
    required this.onPressed,
    required this.child,
    this.scaleDuration = const Duration(milliseconds: 100),
    this.scaleFactor = 0.1,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation animation;
  var isPressed = false;

  void setIsPressed(bool newValue) {
    setState(() => isPressed = newValue);
    runAnimation();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutBack,
      reverseCurve: Curves.easeInOutBack,
    );
  }

  void runAnimation() => isPressed ? animationController.forward() : animationController.reverse();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animationController,
        builder: (_, child) {
          final scale = (1 - animation.value * widget.scaleFactor).toDouble();

          return Transform.scale(
            scale: scale,
            child: Listener(
              onPointerDown: (_) => setIsPressed(true),
              onPointerUp: (event) {
                if (!event.position.isOutsideOf(context.findRenderObject()! as RenderBox)) {
                  if (widget.onPressed != null) {
                    widget.onPressed!();
                  }
                }

                setIsPressed(false);
              },
              onPointerMove: (event) {
                if (event.position.isOutsideOf(context.findRenderObject()! as RenderBox)) {
                  setIsPressed(false);
                } else {
                  setIsPressed(true);
                }
              },
              child: widget.child,
            ),
          );
        },
        child: widget.child,
      );
}
