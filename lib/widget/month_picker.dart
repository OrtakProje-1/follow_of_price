import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class MyMonthPicker extends StatefulWidget {
  final DateTime maxTime;
  final DateTime minTime;
  final DateTime initialTime;
  final double height;
  const MyMonthPicker(
      {Key? key,
      required this.maxTime,
      required this.minTime,
      required this.initialTime,
      this.height = 150})
      : super(key: key);

  @override
  State<MyMonthPicker> createState() => _MyMonthPickerState();
}

class _MyMonthPickerState extends State<MyMonthPicker> {
  int get minYear => widget.minTime.year;
  int get maxYear => widget.maxTime.year;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  @override
  void initState() {
    monthController =
        FixedExtentScrollController(initialItem: widget.initialTime.month-1);
    yearController =
        FixedExtentScrollController(initialItem: (widget.initialTime.year-minYear));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Const.buildTitle("İptal"),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context,DateTime(yearController.selectedItem+minYear,monthController.selectedItem+1));
                  },
                  child: Const.buildContent("Tamam", textSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker.builder(
                    scrollController: monthController,
                    itemExtent: 30,
                    childCount: 12,
                    onSelectedItemChanged: (d) {},
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          Const.months[index],
                          style: TextStyle(
                            color: bloc.isDarkTheme ? white : black, 
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "|",
                  style: TextStyle(
                    fontSize: 22,
                    color: bloc.isDarkTheme ? white : black,
                  ),
                ),
                Expanded(
                  child: CupertinoPicker.builder(
                    scrollController: yearController,
                    itemExtent: 30,
                    childCount: maxYear - minYear + 1,
                    onSelectedItemChanged: (d) {},
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          (index + minYear).toString(),
                          style: TextStyle(
                            color: bloc.isDarkTheme ? white : black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
