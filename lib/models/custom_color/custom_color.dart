import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

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

  factory CustomColor.fromMap(Map<String, dynamic> map) => CustomColor(
        code: map['code'] as int,
        isDay: map['isDay'] as bool,
        color: map['color'] as Color,
      );

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
