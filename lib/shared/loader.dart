import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  const Loader(
      {Key key, this.width = 50.0, this.height = 50.0, this.fit = BoxFit.cover})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        child: Lottie.asset("assets/lotties/loader.json", fit: this.fit));
  }
}
