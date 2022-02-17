import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class BackgroundWidget extends StatefulWidget {
  final Widget child;
  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  // @override
  // void initState() {
  //   bloc.addThemeListener(() {
  //     if(mounted) setState(() {});
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bloc.isDarkTheme ? Colors.black : white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ClipPath(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Const.backgroundColor,
              ),
              clipper: MyClipper(),
            ),
          ),
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.lineTo(0, h * 0.75);
    path.quadraticBezierTo(w / 4, h * 0.60, w / 2, h * 0.75);
    path.quadraticBezierTo(w * 0.75, h * 0.90, w, h * 0.75);
    path.lineTo(w, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
