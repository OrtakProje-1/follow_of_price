import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Category {
  String name;
  String? imagePath;
  int id;
  Category({
    required this.name,
    required this.imagePath,
    required this.id,
  });

  Widget get image {
    return SvgPicture.asset("assets/svg/$imagePath");
  }

  Category copyWith({
    String? name,
    String? imagePath,
    int? id,
  }) {
    return Category(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'id': id,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      imagePath: map['imagePath'],
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() => 'Category(name: $name, imagePath: $imagePath, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Category &&
      other.name == name &&
      other.imagePath == imagePath &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ imagePath.hashCode ^ id.hashCode;
}
