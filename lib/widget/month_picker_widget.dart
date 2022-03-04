import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class MonthPickerWidget extends StatefulWidget {
  final DateTime initialTime;
  final ValueChanged<DateTime>? onChanged;
  const MonthPickerWidget({Key? key, required this.initialTime, this.onChanged})
      : super(key: key);

  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  late DateTime initialTime;

  @override
  void initState() {
    initialTime = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bloc.isDarkTheme ? black : white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: grey.withOpacity(0.2),
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                skipMonth(-1);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: bloc.isDarkTheme ? white : black,
              )),
          RawMaterialButton(
            onPressed: () {
              Const.showMyMonthPicker(context, initialTime: widget.initialTime)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    initialTime = value;
                  });
                  callUpdate(initialTime);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Const.buildContent(
                  Const.getTimeText(initialTime, isMonth: true)),
            ),
          ),
          IconButton(
            onPressed: () {
              skipMonth(1);
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: bloc.isDarkTheme ? white : black,
            ),
          ),
        ],
      ),
    );
  }

  void skipMonth(int i) {
    initialTime = DateTime(initialTime.year, initialTime.month + i);
    setState(() {});
    callUpdate(initialTime);
  }

  void callUpdate(DateTime time) {
    if (widget.onChanged != null) {
      widget.onChanged!(time);
    }
  }
}
