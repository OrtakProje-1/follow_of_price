import 'package:flutter/material.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/util/const.dart';

class TotalPrice extends StatefulWidget {
  final DateTime month;
  final TotalType type;
  final double textSize;
  const TotalPrice(
      {Key? key, required this.month, required this.type, this.textSize = 25})
      : super(key: key);

  @override
  State<TotalPrice> createState() => _TotalPriceState();
}

class _TotalPriceState extends State<TotalPrice> {
  TotalType get totalType => widget.type;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Price>>(
      stream: bloc.pricesStream,
      initialData: bloc.prices,
      builder: (context, snapshot) {
        PricesAmount amounts = getPricesAmount(snapshot.data!);
        double amount = 0;

        if (totalType == TotalType.expenses) {
          amount = amounts.expense;
        } else if (totalType == TotalType.salary) {
          amount = amounts.salary;
        } else {
          amount = amounts.salary - amounts.expense;
        }
        return Row(
          children: [
            Expanded(
                child: Const.buildContent(amount.toStringAsFixed(2) + " ₺",
                    textSize: 17, minSize: 10)),
          ],
        );
      },
    );
  }

  PricesAmount getPricesAmount(List<Price> prices) {
    double totalSalary = 0;
    double totalExpense = 0;

    List<Price> monthPrices = bloc.getPricesFromMonth(widget.month);

    for (var s in monthPrices) {
      if (s.isExpense) {
        totalExpense += s.amount;
      } else {
        totalSalary += s.amount;
      }
    }
    return PricesAmount(expense: totalExpense, salary: totalSalary);
  }
}

class PricesAmount {
  double expense;
  double salary;
  PricesAmount({required this.expense, required this.salary});
}

enum TotalType { expenses, salary, total }
