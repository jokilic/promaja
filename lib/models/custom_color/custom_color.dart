import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'custom_color.g.dart';

@HiveType(typeId: 2)
class CustomColor extends HiveObject {
  @HiveField(1)
  final int code;
  @HiveField(2)
  final bool isDay;
  @HiveField(3)
  final Color color;

  CustomColor({
    required this.code,
    required this.isDay,
    required this.color,
  });

  CustomColor copyWith({
    int? code,
    bool? isDay,
    Color? color,
  }) =>
      CustomColor(
        code: code ?? this.code,
        isDay: isDay ?? this.isDay,
        color: color ?? this.color,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
        'isDay': isDay,
        'color': color,
      };

  factory CustomColor.fromMap(Map<String, dynamic> map) => CustomColor(
        code: map['code'] as int,
        isDay: map['isDay'] as bool,
        color: map['color'] as Color,
      );

  String toJson() => json.encode(toMap());

  factory CustomColor.fromJson(String source) => CustomColor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CustomColor(code: $code, isDay: $isDay, color: $color)';

  @override
  bool operator ==(covariant CustomColor other) {
    if (identical(this, other)) {
      return true;
    }

    return other.code == code && other.isDay == isDay && other.color == color;
  }

  @override
  int get hashCode => code.hashCode ^ isDay.hashCode ^ color.hashCode;
}
