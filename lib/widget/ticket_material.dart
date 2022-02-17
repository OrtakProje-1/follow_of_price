import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/mask_ticket_painter.dart';

///Main class of plugin, that combine [MaskTicketPainter] as mask between
///left an right part of ticket.
class TicketMaterial extends StatefulWidget {
  final int flexLefSize;
  final int flexMaskSize;
  final int flexRightSize;
  final Color colorBackground;
  final Color colorShadow;
  final double shadowSize;
  final double lineWidth;
  final double radiusBorder;
  final double marginBetweenCircles;
  final Widget leftChild;
  final Widget rightChild;
  final Function()? tapHandler;
  final bool useAnimationScaleOnTap;
  final double lowerBoundAnimation;

  const TicketMaterial({
    this.flexLefSize = 70,
    this.flexMaskSize = 5,
    this.flexRightSize = 20,
    this.lineWidth = 10,
    this.marginBetweenCircles = 3,
    required this.leftChild,
    required this.rightChild,
    required this.colorBackground,
    this.colorShadow = Colors.grey,
    this.shadowSize = 1.5,
    this.radiusBorder = 0,
    this.tapHandler,
    this.useAnimationScaleOnTap = true,
    this.lowerBoundAnimation = 0.95,
  });

  @override
  _TicketMaterialState createState() => _TicketMaterialState();
}

class _TicketMaterialState extends State<TicketMaterial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: widget.lowerBoundAnimation,
      upperBound: 1,
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  ///Launch revers animation of ticket(setting scale to default size).
  void _tapDown(details) {
    if (widget.useAnimationScaleOnTap) {
      _controller.reverse();
    }

    if (widget.tapHandler != null) {
      widget.tapHandler!();
    }
  }

  ///This trigger immediately before onTap event.
  ///Launch animation of changing scale ticket(reducing size of ticket).
  void _tapUp(details) {
    if (widget.useAnimationScaleOnTap) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: _tapUp,
      onPanDown: _tapDown,
      child: ScaleTransition(
        scale: _controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:const EdgeInsets.all(16),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: widget.colorBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.radiusBorder),
                    bottomLeft: Radius.circular(widget.radiusBorder),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colorShadow,
                      blurRadius: 0.5,
                      offset: Offset(-0.5, widget.shadowSize),
                    ),
                  ]),
              child: widget.leftChild,
            ),
            SizedBox(
              height: 20,
              width: double.maxFinite,
              child: CustomPaint(
                painter: MaskTicketPainter(
                  lineHeight: 3,
                    lineWidth: widget.lineWidth,
                    marginBetweenCircles: widget.marginBetweenCircles,
                    colorBg: widget.colorBackground,
                    colorShadow: widget.colorShadow,
                    shadowSize: widget.shadowSize),
              ),
            ),
            Container(
               padding: EdgeInsets.all(16),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: widget.colorBackground,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(widget.radiusBorder),
                    topRight: Radius.circular(widget.radiusBorder),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: widget.colorShadow,
                        blurRadius: 0.5,
                        offset: Offset(0.5, widget.shadowSize)),
                  ]),
              child: widget.rightChild,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
