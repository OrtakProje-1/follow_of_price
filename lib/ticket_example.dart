import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class Ticket extends StatefulWidget {
  final Widget child;
  final double dividerWidth;
  final double dividerHeight;
  final double dividerPadding;

  final double bottomClipHeight;
  final double bottomClipWidth;

  const Ticket({
    Key? key,
    required this.child,
    this.dividerPadding = 2,
    this.dividerHeight = 3,
    this.dividerWidth = 5,
    this.bottomClipHeight=10,
    this.bottomClipWidth=15,
  }) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 16,
                            color: Const.primaryColor.withOpacity(0.7)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: bloc.isDarkTheme ? Const.backgroundColor : white,
                              borderRadius:const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: TicketClipper(),
                          child: Container(
                            height: 20,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: bloc.isDarkTheme ? Const.backgroundColor : white,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double max = constraints.maxWidth;
                                int count = max ~/
                                    (widget.dividerWidth +
                                        (2 * widget.dividerPadding));
                                return Row(
                                  children: List.generate(count, (index) {
                                    return Container(
                                      height: widget.dividerHeight,
                                      width: widget.dividerWidth,
                                      decoration: BoxDecoration(
                                        color: grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: widget.dividerPadding),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ClipPath(
                            clipper: TicketClipper2(width: widget.bottomClipWidth, height: widget.bottomClipHeight),
                            child: Container(
                              color: bloc.isDarkTheme ? Const.backgroundColor : white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ],
    );
  }

  Widget buildWidget(String label, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Const.buildTitle(label),
        3.height,
        Const.buildContent(content),
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    double half = h / 2;
    Path path = Path();
    path.lineTo(w, 0);
    // path.lineTo(w - half, half);

    // path.quadraticBezierTo(w-(1.3*half), half, w, h);

    double s=1.8;

    path.quadraticBezierTo(w-half, s, w-half, half);
    path.quadraticBezierTo(w-half, h-s, w, h);

    // path.lineTo(w, h);
    path.lineTo(0, h);

    path.quadraticBezierTo(half, h-s, half, half);
    path.quadraticBezierTo(half, s, 0, 0);
    // path.quadraticBezierTo((1.3*half), half, 0, 0);
    
    // path.lineTo(half, half);
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class TicketClipper2 extends CustomClipper<Path> {
  TicketClipper2({this.width = 10, this.height = 10});

  final double width;
  final double height;
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.lineTo(w, 0);
    path.lineTo(w, h);

    int count = w ~/ width;

    double space = (w - (count * width)) / 2;

    //? kenardaki boşlukşar sıfırlandı
    double width2 = w / count;
    space = 0;
    //? işlem sonu

    path.lineTo(w - space, h);

    double x = w - space;

    for (int i = 1; i <= count; i++) {
      x -= width2 / 2;
      path.lineTo(x, h - height);
      x -= width2 / 2;
      path.lineTo(x, h);
    }

    path.lineTo(0, h);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
