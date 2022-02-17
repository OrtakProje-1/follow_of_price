import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:follow_of_price/models/category.dart';

class Budget {
  int id;
  Color color;
  double amount;
  Category category;
  Budget({
    required this.id,
    required this.color,
    required this.amount,
    required this.category,
  });

  Budget copyWith({
    int? id,
    Color? color,
    double? amount,
    Category? category,
  }) {
    return Budget(
      id: id ?? this.id,
      color: color ?? this.color,
      amount: amount ?? this.amount,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color.value,
      'amount': amount,
      'category': category.toMap(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id']?.toInt() ?? 0,
      color: Color(map['color']),
      amount: map['amount']?.toDouble() ?? 0.0,
      category: Category.fromMap(map['category']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Budget(id: $id, color: $color, amount: $amount, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Budget &&
      other.id == id &&
      other.color == color &&
      other.amount == amount &&
      other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      color.hashCode ^
      amount.hashCode ^
      category.hashCode;
  }
}
