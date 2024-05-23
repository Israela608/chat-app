import 'package:flutter/material.dart';

class LoadingStack extends StatelessWidget {
  const LoadingStack({
    super.key,
    required this.loader,
    required this.child,
  });

  final Widget loader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: loader,
        )
      ],
    );
  }
}
