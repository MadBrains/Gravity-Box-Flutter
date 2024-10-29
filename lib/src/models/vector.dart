import 'package:gravity_box/src/mixins/stringify.dart';

class Vector2 with Stringify {
  const Vector2(this.x, this.y);

  factory Vector2.zero() => const Vector2(0, 0);

  final double x;
  final double y;

  Vector2 get rounded => Vector2(
        x.roundToDouble(),
        y.roundToDouble(),
      );

  @override
  Map<String, dynamic> get mappedFields => {
        'x': x,
        'y': y,
      };

  Vector2 copyWith({
    double? x,
    double? y,
  }) =>
      Vector2(
        x ?? this.x,
        y ?? this.y,
      );

  Vector2 clone() => copyWith();

  Vector2 clamp(
    Vector2 min,
    Vector2 max,
  ) =>
      copyWith(
        x: x.clamp(min.x, max.x),
        y: y.clamp(min.y, max.y),
      );

  /// Add two vectors.
  Vector2 operator +(Vector2 other) => copyWith(
        x: x + other.x,
        y: y + other.y,
      );

  /// Scale vector.
  Vector2 operator *(double scale) => copyWith(
        x: x * scale,
        y: y * scale,
      );
}
