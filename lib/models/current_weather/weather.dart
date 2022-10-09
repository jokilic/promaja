import 'dart:convert';

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  Weather copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) =>
      Weather(
        id: id ?? this.id,
        main: main ?? this.main,
        description: description ?? this.description,
        icon: icon ?? this.icon,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };

  factory Weather.fromMap(Map<String, dynamic> map) => Weather(
        id: map['id']?.toInt() ?? 0,
        main: map['main'] ?? '',
        description: map['description'] ?? '',
        icon: map['icon'] ?? '',
      );

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) => Weather.fromMap(json.decode(source));

  @override
  String toString() => 'Weather(id: $id, main: $main, description: $description, icon: $icon)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Weather && other.id == id && other.main == main && other.description == description && other.icon == icon;
  }

  @override
  int get hashCode => id.hashCode ^ main.hashCode ^ description.hashCode ^ icon.hashCode;
}
