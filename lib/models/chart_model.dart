import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';

class ChartModel {
  String name;
  List<Price> prices;
  Color color;
  ChartModel({
    required this.name,
    required this.prices,
    required this.color,
  });

  double get totalAmount => bloc.getAmountFromPrices(prices);
  
  ChartModel copyWith({
    String? name,
    List<Price>? prices,
    Color? color,
  }) {
    return ChartModel(
      name: name ?? this.name,
      prices: prices ?? this.prices,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'prices': prices.map((x) => x.toMap()).toList(),
      'color': color.value,
    };
  }

  factory ChartModel.fromMap(Map<String, dynamic> map) {
    return ChartModel(
      name: map['name'] ?? '',
      prices: List<Price>.from(map['prices']?.map((x) => Price.fromMap(x))),
      color: Color(map['color']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChartModel.fromJson(String source) =>
      ChartModel.fromMap(json.decode(source));

  @override
  String toString() => 'ChartModel(name: $name, prices: $prices, color: $color)';

  @override
  int get hashCode => name.hashCode ^ prices.hashCode ^ color.hashCode;

  @override
  // ignore: unnecessary_overrides
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChartModel &&
      other.name == name &&
      listEquals(other.prices, prices) &&
      other.color == color;
  }
}
