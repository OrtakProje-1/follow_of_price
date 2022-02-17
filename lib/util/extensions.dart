import 'package:flutter/material.dart';

extension ContextExt on BuildContext{
  Future<T?> push<T>(Widget page)async{
    return Navigator.push<T>(this, MaterialPageRoute(builder: (_)=>page));
  }
  
  Future<void> pushReplacement(Widget page)async{
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (_)=>page));
  }

  double get width{
    return size.width;
  }

  double get height{
    return size.height;
  }

  Size get size{
    return MediaQuery.of(this).size;
  }

}

extension NumExt on num{
  SizedBox get width{
    return SizedBox(width: toDouble());
  }
  
  SizedBox get height{
    return SizedBox(height: toDouble());
  }
}

extension CompareDates on DateTime {
  bool isSameDateAs(DateTime other) {
    return this.day == other.day &&
        this.month == other.month &&
        this.year == other.year;
  }
  
  bool isSameMonthAs(DateTime other) {
    return this.month == other.month &&
        this.year == other.year;
  }
}