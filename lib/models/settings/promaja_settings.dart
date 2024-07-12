import 'package:hive_ce/hive.dart';

import 'appearance/appearance_settings.dart';
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
  @HiveField(3)
  final AppearanceSettings appearance;

  PromajaSettings({
    required this.notification,
    required this.widget,
    required this.unit,
    required this.appearance,
  });

  PromajaSettings copyWith({
    NotificationSettings? notification,
    WidgetSettings? widget,
    UnitSettings? unit,
    AppearanceSettings? appearance,
  }) =>
      PromajaSettings(
        notification: notification ?? this.notification,
        widget: widget ?? this.widget,
        unit: unit ?? this.unit,
        appearance: appearance ?? this.appearance,
      );

  @override
  String toString() => 'PromajaSettings(notification: $notification, widget: $widget, unit: $unit, appearance: $appearance)';

  @override
  bool operator ==(covariant PromajaSettings other) {
    if (identical(this, other)) {
      return true;
    }

    return other.notification == notification && other.widget == widget && other.unit == unit && other.appearance == appearance;
  }

  @override
  int get hashCode => notification.hashCode ^ widget.hashCode ^ unit.hashCode ^ appearance.hashCode;
}
