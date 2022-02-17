import 'dart:convert';

import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';

class Price {
  double amount;
  DateTime time;
  bool isExpense;
  Category category;
  String description;
  PaymentMethod paymentMethod;
  Price({
    required this.amount,
    required this.time,
    required this.isExpense,
    required this.category,
    required this.description,
    required this.paymentMethod,
  });

  Price copyWith({
    double? amount,
    DateTime? time,
    bool? isExpense,
    Category? category,
    String? description,
    PaymentMethod? paymentMethod,
  }) {
    return Price(
      amount: amount ?? this.amount,
      time: time ?? this.time,
      isExpense: isExpense ?? this.isExpense,
      category: category ?? this.category,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'time': time.millisecondsSinceEpoch,
      'isExpense': isExpense,
      'category': category.toMap(),
      'description': description,
      'paymentMethod': paymentMethod.toMap(),
    };
  }

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      amount: map['amount']?.toDouble() ?? 0.0,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      isExpense: map['isExpense'] ?? false,
      category: Category.fromMap(map['category']),
      description: map['description'] ?? '',
      paymentMethod: PaymentMethod.fromMap(map['paymentMethod']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Price.fromJson(String source) => Price.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Price(amount: $amount, time: $time, isExpense: $isExpense, category: $category, description: $description, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Price &&
      other.amount == amount &&
      other.time == time &&
      other.isExpense == isExpense &&
      other.category == category &&
      other.description == description &&
      other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
      time.hashCode ^
      isExpense.hashCode ^
      category.hashCode ^
      description.hashCode ^
      paymentMethod.hashCode;
  }
}
