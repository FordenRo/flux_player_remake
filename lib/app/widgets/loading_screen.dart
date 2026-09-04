import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({required this.builder, required this.future, super.key});

  final Future<void> future;
  final Widget Function(BuildContext context) builder;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState<T> extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final fadeAnimation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut,
  );
  late final scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
    CurvedAnimation(parent: controller, curve: Curves.fastEaseInToSlowEaseOut),
  );

  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await controller.forward();
    await widget.future;
    await controller.animateBack(0);
    setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) => isLoaded
      ? Builder(builder: widget.builder)
      : Scaffold(
          body: Center(
            child: ScaleTransition(
              scale: scaleAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Image.asset('assets/logo.png', width: 180),
              ),
            ),
          ),
        );
}
