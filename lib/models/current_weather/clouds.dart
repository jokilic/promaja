import 'dart:convert';

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  Clouds copyWith({
    int? all,
  }) =>
      Clouds(
        all: all ?? this.all,
      );

  Map<String, dynamic> toMap() => {
        'all': all,
      };

  factory Clouds.fromMap(Map<String, dynamic> map) => Clouds(
        all: map['all']?.toInt() ?? 0,
      );

  String toJson() => json.encode(toMap());

  factory Clouds.fromJson(String source) => Clouds.fromMap(json.decode(source));

  @override
  String toString() => 'Clouds(all: $all)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Clouds && other.all == all;
  }

  @override
  int get hashCode => all.hashCode;
}
