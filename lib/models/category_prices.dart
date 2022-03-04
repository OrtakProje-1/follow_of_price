import 'dart:convert';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';

class CategoryPrices {
  Category category;
  List<Price> prices;
  CategoryPrices({
    required this.category,
    required this.prices,
  });

  double get totalAmount{
    return bloc.getAmountFromPrices(prices);
  }

  CategoryPrices copyWith({
    Category? category,
    List<Price>? prices,
  }) {
    return CategoryPrices(
      category: category ?? this.category,
      prices: prices ?? this.prices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'prices': prices.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryPrices.fromMap(Map<String, dynamic> map) {
    return CategoryPrices(
      category: Category.fromMap(map['category']),
      prices: List<Price>.from(map['prices']?.map((x) => Price.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryPrices.fromJson(String source) =>
      CategoryPrices.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryPrices(category: $category, prices: $prices)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryPrices && other.category == category;
  }

  @override
  int get hashCode => category.hashCode ^ prices.hashCode;
}
