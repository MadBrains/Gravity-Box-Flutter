import 'package:flutter/material.dart';
import 'package:gravity_box/gravity_box.dart';
import 'package:gravity_box/src/mixins/mixins.dart';

/// {@template GravityObject}
/// A model that represents an object in the [GravityBox].
///
/// It contains the info of the object such as its [size], [position], [velocity],
/// whether it [canRoll] or not, [angle] and [angularVelocity].
///
/// The [widget] is the widget that will be displayed as the object.
/// {@endtemplate}
class GravityObject with Stringify {
  /// Creates a [GravityObject].
  ///
  /// {@macro GravityObject}
  const GravityObject({
    required this.size,
    this.position = const Vector2(0, 0),
    this.canRoll = false,
    this.angle = 0,
    this.angularVelocity = 0,
    required this.widget,
  }) : _velocity = const Vector2(0, 0);

  const GravityObject._({
    required this.size,
    this.position = const Vector2(0, 0),
    this.canRoll = false,
    this.angle = 0,
    this.angularVelocity = 0,
    required this.widget,
    required Vector2 velocity,
  }) : _velocity = velocity;

  /// The size of the object, used to calculate its bounding box.
  ///
  /// The size of the [widget] is not respected.
  final double size;

  /// The initial position of the object on the constraints of [GravityBox].
  final Vector2 position;

  /// Whether the object can roll or not.
  final bool canRoll;

  /// The rotation angle of the object in clockwise radians.
  final double angle;

  /// The angular velocity of the object.
  final double angularVelocity;

  /// The widget that will be displayed as the object.
  final Widget widget;

  final Vector2 _velocity;

  /// The velocity of the object.

  Vector2 get velocity => _velocity;

  /// The radius of the object.
  ///
  /// It is half of the [size].
  double get radius => size / 2;

  /// The bounding box of the object on the constraints of [GravityBox].
  ///
  /// It is a square with the [size], starting in the [position].
  Rect get rect => Offset(position.x, position.y) & Size.square(size);

  /// Creates a new [GravityObject] with the given properties.
  ///
  /// Any null value will use the value from the current object.
  GravityObject copyWith({
    Widget? widget,
    double? size,
    Vector2? position,
    Vector2? velocity,
    bool? canRoll,
    double? angle,
    double? angularVelocity,
  }) =>
      GravityObject._(
        widget: widget ?? this.widget,
        size: size ?? this.size,
        position: position ?? this.position,
        velocity: velocity ?? this.velocity,
        canRoll: canRoll ?? this.canRoll,
        angle: angle ?? this.angle,
        angularVelocity: angularVelocity ?? this.angularVelocity,
      );

  @override
  Map<String, dynamic> get mappedFields => {
        'widget': widget,
        'size': size,
        'position': position,
        'velocity': velocity,
        'canRoll': canRoll,
        'angle': angle,
        'angularVelocity': angularVelocity,
      };
}
