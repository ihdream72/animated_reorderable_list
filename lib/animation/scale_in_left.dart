import 'package:flutter/cupertino.dart';

class ScaleInLeft extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  const ScaleInLeft({Key? key,required this.child,required this.animation}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.centerLeft,
      scale: animation,
      child: child,);
  }
}