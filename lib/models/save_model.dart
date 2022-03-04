import 'dart:convert';
import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/models/user.dart';

class SaveModel {
  List<Price> prices;
  List<Budget> budgets;
  User user;
  SaveModel({
    required this.prices,
    required this.budgets,
    required this.user,
  });

  SaveModel copyWith({
    List<Price>? prices,
    List<Budget>? budgets,
    User? user,
  }) {
    return SaveModel(
      prices: prices ?? this.prices,
      budgets: budgets ?? this.budgets,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prices': prices.map((x) => x.toMap()).toList(),
      'budgets': budgets.map((x) => x.toMap()).toList(),
      'user': user.toMap(),
    };
  }

  factory SaveModel.fromMap(Map<String, dynamic> map) {
    return SaveModel(
      prices: List<Price>.from(map['prices']?.map((x) => Price.fromMap(x))),
      budgets: List<Budget>.from(map['budgets']?.map((x) => Budget.fromMap(x))),
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveModel.fromJson(String source) => SaveModel.fromMap(json.decode(source));

  @override
  String toString() => 'SaveModel(prices: $prices, budgets: $budgets, user: $user)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SaveModel &&
      other.user == user;
  }

  @override
  int get hashCode => prices.hashCode ^ budgets.hashCode ^ user.hashCode;
}
