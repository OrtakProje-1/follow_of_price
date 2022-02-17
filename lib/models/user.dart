import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum Genre {
  male,
  female,
}

class User {
  int id;
  String name;
  String? imagePath;
  double? expensesLimit;
  String? password;
  Genre genre;
  User({
    required this.id,
    required this.name,
    this.imagePath,
    this.expensesLimit,
    this.password,
    required this.genre,
  });

  User copyWith({
    int? id,
    String? name,
    String? imagePath,
    double? expensesLimit,
    String? password,
    Genre? genre,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      expensesLimit: expensesLimit ?? this.expensesLimit,
      password: password ?? this.password,
      genre: genre ?? this.genre,
    );
  }

  Widget image({
    double? size,
    double margin = 0,
    double padding = 0,
    Color color = Colors.white,
    double radius = 0,
  }) {
    return Container(
      width: size ?? 40,
      height: size ?? 40,
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: getImageProvider,
        ),
      ),
    );
  }

  ImageProvider get getImageProvider {
    ImageProvider image;
    if (imagePath != null && (imagePath??"").isNotEmpty) {
      image = FileImage(File(imagePath!));
    } else {
      image = AssetImage(
          "assets/images/${genre == Genre.male ? "male.png" : "female.png"}");
    }
    return image;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'expensesLimit': expensesLimit,
      'password': password,
      'genre': genre.index,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      expensesLimit: map['expensesLimit']?.toDouble(),
      password: map['password'],
      genre: Genre.values[map['genre']],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, image: $image, expensesLimit: $expensesLimit, password: $password, genre: $genre)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.expensesLimit == expensesLimit &&
        other.password == password &&
        other.genre == genre;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        expensesLimit.hashCode ^
        password.hashCode ^
        genre.hashCode;
  }
}
