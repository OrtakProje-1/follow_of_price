import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
// import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:follow_of_price/widget/calculator/calculator.dart';
import 'package:intl/intl.dart' as intl;

/// Signature for callbacks that report that the [SimpleCalculator] value has changed.
typedef CalcChanged = void Function(
    String? key, double? value, String? expression);

/// Controller for calculator.
class CalcController extends ChangeNotifier {
  final Calculator _calc;
  String _acLabel = 'AC';

  /// Create a [CalcController] with [maximumDigits] is 10 and maximumFractionDigits of [numberFormat] is 6.
  CalcController({maximumDigits = 10})
      : _calc = Calculator(maximumDigits: maximumDigits);

  /// Create a [Calculator].
  CalcController.numberFormat(intl.NumberFormat numberFormat, int maximumDigits)
      : _calc = Calculator.numberFormat(numberFormat, maximumDigits);

  /// Display string
  String? get display => _calc.displayString;

  /// Display value
  double? get value => _calc.displayValue;

  /// Expression
  String? get expression => _calc.expression;

  /// Label for the "AC" button, "AC" or "C".
  String get acLabel => _acLabel;

  /// The [NumberFormat] used for display
  intl.NumberFormat get numberFormat => _calc.numberFormat;

  /// Set the value.
  void setValue(double val) {
    _calc.setValue(val);
    _acLabel = 'C';
    notifyListeners();
  }

  /// Add digit to the display.
  void addDigit(int num) {
    _calc.addDigit(num);
    _acLabel = 'C';
    notifyListeners();
  }

  /// Add a decimal point.
  void addPoint() {
    _calc.addPoint();
    _acLabel = 'C';
    notifyListeners();
  }

  /// Clear all entries.
  void allClear() {
    _calc.allClear();
    notifyListeners();
  }

  /// Clear value to zero.
  void clear() {
    _calc.clear();
    _acLabel = 'AC';
    notifyListeners();
  }

  /// Perform operations.
  void operate() {
    _calc.operate();
    _acLabel = 'AC';
    notifyListeners();
  }

  /// Remove the last digit.
  void removeDigit() {
    _calc.removeDigit();
    notifyListeners();
  }

  /// Set the operation to addition.
  void setAdditionOp() {
    _calc.setOperator('+');
    notifyListeners();
  }

  /// Set the operation to subtraction.
  void setSubtractionOp() {
    _calc.setOperator('-');
    notifyListeners();
  }

  /// Set the operation to multiplication.
  void setMultiplicationOp() {
    _calc.setOperator('×');
    notifyListeners();
  }

  /// Set the operation to division.
  void setDivisionOp() {
    _calc.setOperator('÷');
    notifyListeners();
  }

  /// Set a percent sign.
  void setPercent() {
    _calc.setPercent();
    _acLabel = 'C';
    notifyListeners();
  }

  /// Toggle between a plus sign and a minus sign.
  void toggleSign() {
    _calc.toggleSign();
    notifyListeners();
  }
}

/// Holds the color and typography values for the [SimpleCalculator].
class CalculatorThemeData {

  /// The color of the display panel background.
  final Color? displayColor;

  /// The background color of the expression area.
  final Color? expressionColor;

  /// The background color of operator buttons.
  final Color? operatorColor;

  /// The background color of command buttons.
  final Color? commandColor;

  /// The background color of number buttons.
  final Color? numColor;

  /// The text style to use for the display panel.
  final TextStyle? displayStyle;

  /// The text style to use for the expression area.
  final TextStyle? expressionStyle;

  /// The text style to use for operator buttons.
  final TextStyle? operatorStyle;

  /// The text style to use for command buttons.
  final TextStyle? commandStyle;

  /// The text style to use for number buttons.
  final TextStyle? numStyle;

  final double borderRadius;

  const CalculatorThemeData(
      {this.displayColor,
      this.expressionColor,
      this.operatorColor,
      this.commandColor,
      this.numColor,
      this.displayStyle,
      this.expressionStyle,
      this.operatorStyle,
      this.commandStyle,
      this.borderRadius=5,
      this.numStyle,});
}

/// SimpleCalculator
///
/// {@tool sample}
///
/// This example shows a simple [SimpleCalculator].
///
/// ```dart
/// SimpleCalculator(
///   value: 123.45,
///   hideExpression: true,
///   onChanged: (key, value, expression) {
///     /*...*/
///   },
///   theme: const CalculatorThemeData(
///     displayColor: Colors.black,
///     displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
///   ),
/// )
/// ```
/// {@end-tool}
///
class SimpleCalculator extends StatefulWidget {
  /// Visual properties for this widget.
  final CalculatorThemeData? theme;

  /// Whether to show surrounding borders.
  final bool hideSurroundingBorder;

  /// Whether to show expression area.
  final bool hideExpression;

  /// The value currently displayed on this calculator.
  final double value;

  /// Called when the button is tapped or the value is changed.
  final CalcChanged? onChanged;

  /// Called when the display area is tapped.
  final Function(double?, TapDownDetails)? onTappedDisplay;

  /// The [NumberFormat] used for display
  final intl.NumberFormat? numberFormat;

  /// Maximum number of digits on display.
  final int maximumDigits;

  /// Controller for calculator.
  final CalcController? controller;

  const SimpleCalculator({
    Key? key,
    this.theme,
    this.hideExpression = false,
    this.value = 0,
    this.onChanged,
    this.onTappedDisplay,
    this.numberFormat,
    this.maximumDigits = 10,
    this.hideSurroundingBorder = false,
    this.controller,
  }) : super(key: key);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  CalcController? _controller;
  String? _acLabel;

  final List<String> _nums = List.filled(10, '', growable: false);
  final _baseStyle = const TextStyle(fontSize: 26);

  void _initController() {
    if (widget.controller == null) {
      if (widget.numberFormat == null) {
        var myLocale = Localizations.localeOf(context);
        var nf = intl.NumberFormat.decimalPattern(myLocale.toLanguageTag())
          ..maximumFractionDigits = 6;
        _controller = CalcController.numberFormat(nf, widget.maximumDigits);
      } else {
        _controller = CalcController.numberFormat(
            widget.numberFormat!, widget.maximumDigits);
      }
    } else {
      _controller = widget.controller;
    }
    _controller!.addListener(_didChangeCalcValue);
  }

  @override
  void didChangeDependencies() {
    _initController();
    for (var i = 0; i < 10; i++) {
      _nums[i] = _controller!.numberFormat.format(i);
    }
    _controller!.allClear();
    _controller!.setValue(widget.value);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SimpleCalculator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller!.removeListener(_didChangeCalcValue);
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Const.outlinedButton("Kaydet",onPressed: (){
            Navigator.pop(context,_controller!.value);
          })
        ],
      ),
      Expanded(
        child: _CalcDisplay(
          hideSurroundingBorder: widget.hideSurroundingBorder,
          hideExpression: widget.hideExpression,
          onTappedDisplay: widget.onTappedDisplay,
          theme: widget.theme,
          controller: _controller,
        ),
      ),
      Expanded(
        child: _getButtons(),
        flex: 5,
      ),
    ]);
  }

  @override
  void dispose() {
    _controller!.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    if (_acLabel == _controller!.acLabel) return;
    setState(() {
      _acLabel = _controller!.acLabel;
    });
  }

  List<List<Btn>> getBtnList() {
    Btn ac = Btn.text(
        text: _acLabel!,
        pressed:
            _acLabel! == "AC" ? _controller!.allClear : _controller!.clear);
    Btn toggle = Btn.text(text: "±", pressed: _controller!.toggleSign);
    Btn mod = Btn.text(text: "%", pressed: _controller!.setPercent);
    Btn bol = Btn.text(text: "÷", pressed: _controller!.setDivisionOp);
    Btn b7 = Btn.text(
        text: "7",
        pressed: () {
          _controller!.addDigit(7);
        });
    Btn b8 = Btn.text(
        text: "8",
        pressed: () {
          _controller!.addDigit(8);
        });
    Btn b9 = Btn.text(
        text: "9",
        pressed: () {
          _controller!.addDigit(9);
        });
    Btn multip = Btn.text(text: "x", pressed: _controller!.setMultiplicationOp);
    Btn b4 = Btn.text(
        text: "4",
        pressed: () {
          _controller!.addDigit(4);
        });
    Btn b5 = Btn.text(
        text: "5",
        pressed: () {
          _controller!.addDigit(5);
        });
    Btn b6 = Btn.text(
        text: "6",
        pressed: () {
          _controller!.addDigit(6);
        });
    Btn subtract = Btn.text(text: "-", pressed: _controller!.setSubtractionOp);
    Btn b1 = Btn.text(
        text: "1",
        pressed: () {
          _controller!.addDigit(1);
        });
    Btn b2 = Btn.text(
        text: "2",
        pressed: () {
          _controller!.addDigit(2);
        });
    Btn b3 = Btn.text(
        text: "3",
        pressed: () {
          _controller!.addDigit(3);
        });
    Btn addition = Btn.text(text: "+", pressed: _controller!.setAdditionOp);
    Btn b0 = Btn.text(
        text: "0",
        pressed: () {
          _controller!.addDigit(0);
        });
    Btn sep = Btn.text(text: ",", pressed: _controller!.addPoint);
    Btn remove = Btn.icon(
        icon: Icons.backspace_outlined, pressed: _controller!.removeDigit);
    Btn operate = Btn.text(text: "=", pressed: _controller!.operate);

    List<List<Btn>> list = [
      [ac, toggle, mod, bol],
      [b7, b8, b9, multip],
      [b4, b5, b6, subtract],
      [b1, b2, b3, addition],
      [b0, sep, remove, operate],
    ];

    return list;
  }

  Widget _getButtons() {
    List<List<Btn>> list = getBtnList();

    return Column(
      children: [0, 1, 2, 3, 4].map((i) {
        return Expanded(
          child: Row(
            children: [0, 1, 2, 3].map((ii) {
              Btn btn = list[i][ii];
              bool change = false;
              return Expanded(
                child: StatefulBuilder(builder: (context, state) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(change ? 8 : 25),
                        color: (i == 0 || ii == 3)
                            ? Const.primaryColor.withOpacity(0.2)
                            : (bloc.isDarkTheme ? white : black).withOpacity(0.05)),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 25,end: change ? 8 : 25
                      ),
                      duration:const Duration(milliseconds: 260),
                      builder: (context, v,c) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(v),
                          child: RawMaterialButton(
                            constraints: const BoxConstraints.expand(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                            onPressed: btn.pressed,
                            onHighlightChanged: (s) {
                              state(() {
                                change = s;
                              });
                            },
                            child: btn.child,
                          ),
                        );
                      }
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

}

class _CalcDisplay extends StatefulWidget {
  /// Whether to show surrounding borders.
  final bool? hideSurroundingBorder;

  /// Whether to show expression area.
  final bool? hideExpression;

  /// Visual properties for this widget.
  final CalculatorThemeData? theme;

  /// Controller for calculator.
  final CalcController? controller;

  /// Called when the display area is tapped.
  final Function(double?, TapDownDetails)? onTappedDisplay;

  const _CalcDisplay({
    Key? key,
    this.hideSurroundingBorder,
    this.hideExpression,
    this.onTappedDisplay,
    this.theme,
    this.controller,
  }) : super(key: key);

  @override
  _CalcDisplayState createState() => _CalcDisplayState();
}

class _CalcDisplayState extends State<_CalcDisplay> {
  @override
  void initState() {
    super.initState();
    widget.controller!.addListener(_didChangeCalcValue);
  }

  @override
  void didUpdateWidget(_CalcDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller!.removeListener(_didChangeCalcValue);
      widget.controller!.addListener(_didChangeCalcValue);
    }
  }

  @override
  void dispose() {
    widget.controller!.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.theme?.borderRadius??5)
          ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => widget.onTappedDisplay == null
                  ? null
                  : widget.onTappedDisplay!(widget.controller!.value, details),
              child: Container(
                color: widget.theme?.displayColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: AutoSizeText(
                      widget.controller!.display!,
                      style: widget.theme?.displayStyle ??
                          const TextStyle(fontSize: 50),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !widget.hideExpression!,
            child: Expanded(
              child: Container(
                color: widget.theme?.expressionColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      widget.controller!.expression!,
                      style: widget.theme?.expressionStyle ??
                          const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Btn {
  Widget child;
  VoidCallback pressed;

  Btn({required this.child, required this.pressed});
  Btn.text({required String text, required this.pressed})
      : child = Const.buildContent(text, color:bloc.isDarkTheme ? white : black);
  Btn.icon({required IconData icon, required this.pressed})
      : child = Icon(
          icon,
          color: bloc.isDarkTheme ? white : black,
        );
}
