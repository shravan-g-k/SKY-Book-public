import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(0, 0, 0, 0),
      end: const Color.fromARGB(109, 122, 119, 119),
    ).animate(_controller);
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            const SizedBox(
              height: 300,
            ),
            Positioned(
              top: 90,
              child: Transform(
                transform: Matrix4.rotationX((3.14 / 180) * 60),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: _controller.value * 15),
              child: Image.asset(
                'assets/sky-logo.png',
                height: 100,
              ),
            ),
          ],
        );
      },
    );
  }
}
