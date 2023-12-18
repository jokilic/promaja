import 'dart:convert';

import 'package:hive/hive.dart';

import 'notification/notification_settings.dart';
import 'units/unit_settings.dart';
import 'widget/widget_settings.dart';

part 'promaja_settings.g.dart';

@HiveType(typeId: 12)
class PromajaSettings extends HiveObject {
  @HiveField(0)
  final NotificationSettings notification;
  @HiveField(1)
  final WidgetSettings widget;
  @HiveField(2)
  final UnitSettings unit;

  PromajaSettings({
    required this.notification,
    required this.widget,
    required this.unit,
  });

  PromajaSettings copyWith({
    NotificationSettings? notification,
    WidgetSettings? widget,
    UnitSettings? unit,
  }) =>
      PromajaSettings(
        notification: notification ?? this.notification,
        widget: widget ?? this.widget,
        unit: unit ?? this.unit,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'notification': notification.toMap(),
        'widget': widget.toMap(),
        'unit': unit.toMap(),
      };

  factory PromajaSettings.fromMap(Map<String, dynamic> map) => PromajaSettings(
        notification: NotificationSettings.fromMap(map['notification'] as Map<String, dynamic>),
        widget: WidgetSettings.fromMap(map['widget'] as Map<String, dynamic>),
        unit: UnitSettings.fromMap(map['unit'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory PromajaSettings.fromJson(String source) => PromajaSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PromajaSettings(notification: $notification, widget: $widget, unit: $unit)';

  @override
  bool operator ==(covariant PromajaSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.notification == notification && other.widget == widget && other.unit == unit;
  }

  @override
  int get hashCode => notification.hashCode ^ widget.hashCode ^ unit.hashCode;
}
