import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/price.dart';

class SaveModel {
  List<Price> prices;
  List<Budget> budgets;
  SaveModel({
    required this.prices,
    required this.budgets,
  });

  SaveModel copyWith({
    List<Price>? prices,
    List<Budget>? budgets,
  }) {
    return SaveModel(
      prices: prices ?? this.prices,
      budgets: budgets ?? this.budgets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prices': prices.map((x) => x.toMap()).toList(),
      'budgets': budgets.map((x) => x.toMap()).toList(),
    };
  }

  factory SaveModel.fromMap(Map<String, dynamic> map) {
    return SaveModel(
      prices: List<Price>.from(map['prices']?.map((x) => Price.fromMap(x))),
      budgets: List<Budget>.from(map['budgets']?.map((x) => Budget.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveModel.fromJson(String source) => SaveModel.fromMap(json.decode(source));

  @override
  String toString() => 'SaveModel(prices: $prices, budgets: $budgets)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SaveModel &&
      listEquals(other.prices, prices) &&
      listEquals(other.budgets, budgets);
  }

  @override
  int get hashCode => prices.hashCode ^ budgets.hashCode;
}
