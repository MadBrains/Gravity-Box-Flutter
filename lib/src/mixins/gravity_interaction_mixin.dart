import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:gravity_box/gravity_box.dart';
import 'package:gravity_box/src/extensions.dart';
import 'package:gravity_box/src/widgets/widgets.dart';
import 'package:gravity_sensor/gravity_sensor.dart';

/// A mixin that adds ablity for gravity interaction to a [StatefulWidget]
/// with its [updateObject] method, which is used to update the [GravityObject].
///
/// [isObjectCollidesAtDirection] should be implemented in the mixed class.
///
/// The mixin uses the [GravitySensor] package to get the device's gravity
/// sensor data.
///
/// See also:
///
///  * [GravitySensor], the package used to get the device's gravity sensor data.
///  * [GravityBox], the widget that uses this mixin.
///  * [GravityObject], the model that represents an object in the [GravityBox].
mixin GravityInteractionMixin<T extends StatefulWidget> on State<T> {
  late final StreamSubscription<GravityEvent> _gravityEventsSubscription;

  GravityEvent _lastGravityEvent = const GravityEvent(0, 0, 0);
  BoxConstraints _lastConstraints = const BoxConstraints();

  bool get canUpdate =>
      _lastConstraints.maxWidth.isFinite && _lastConstraints.maxHeight.isFinite && mounted;

  @override
  void initState() {
    super.initState();

    _gravityEventsSubscription = GravitySensor().gravityEvents.listen(_gravityEventsListener);
  }

  void _gravityEventsListener(GravityEvent event) => _lastGravityEvent = event;

  @override
  void dispose() {
    _gravityEventsSubscription.cancel();

    super.dispose();
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return LayoutListener(
      onContraintsChanged: (constraints) => _lastConstraints = constraints,
      child: childBuilder(context),
    );
  }

  /// The proxy method for [build]. Should be used instead of [build].
  Widget childBuilder(BuildContext context);

  /// Checks if the object is colliding with any other object,
  /// widget or with the screen borders at the given direction..
  bool isObjectCollidesAtDirection(
    Direction direction, {
    required GravityObject object,
    required int index,
  });

  /// Updates the [GravityObject] position, velocity and angle based on the gravity.
  ///
  /// The [dt] parameter is the time difference in seconds since the last call.
  ///
  /// The [index] parameter is the index of the object in the list of objects.
  ///
  /// The method returns a new [GravityObject] with the updated values.
  GravityObject updateObject(
    GravityObject source,
    double dt,
    int index,
  ) {
    GravityObject object = source.copyWith(
      velocity: source.velocity + Vector2(-_lastGravityEvent.x, _lastGravityEvent.y) * dt,
    );
    final double size = object.size;
    Vector2 velocity = object.velocity;

    final double maxPositionX = _getMaxPositionX(size);
    final double maxPositionY = _getMaxPositionY(size);

    final Set<Direction> possibleDirections =
        _getPossibleMovingDirections(object: object, index: index).toSet();
    final Set<Direction> actualDirections = _getActualMovingDirections(velocity).toSet();

    if (!actualDirections.isMovingHorizontal(possibleDirections)) {
      velocity = velocity.copyWith(x: 0);
    }
    if (!actualDirections.isMovingVertical(possibleDirections)) {
      velocity = velocity.copyWith(y: 0);
    }

    final bool isColliding = possibleDirections.isNotFull;
    if (isColliding && object.canRoll) {
      final double vel = ((velocity.x != 0) ? velocity.x : velocity.y).abs();
      final bool isRollingClockwise = actualDirections.isRollingClockwise(possibleDirections);

      object = object.copyWith(angularVelocity: (isRollingClockwise ? vel : -vel) / size * pi);
    }

    final Vector2 min = Vector2.zero();
    final Vector2 max = Vector2(maxPositionX, maxPositionY);
    final Vector2 newPosition = (object.position + velocity).clamp(min, max);

    return object.copyWith(
      position: newPosition,
      velocity: velocity,
      angle: object.angle + object.angularVelocity,
    );
  }

  double _getMaxPositionX(double objectSize) => _lastConstraints.maxWidth - objectSize;
  double _getMaxPositionY(double objectSize) => _lastConstraints.maxHeight - objectSize;

  Iterable<Direction> _getPossibleMovingDirections({
    required GravityObject object,
    required int index,
  }) sync* {
    for (final Direction direction in Direction.values) {
      if (_canMoveTo(direction, object: object, index: index)) yield direction;
    }
  }

  Iterable<Direction> _getActualMovingDirections(Vector2 velocity) sync* {
    if (velocity.x.isNegative) yield Direction.left;
    if (velocity.y.isNegative) yield Direction.top;
    if (!velocity.x.isNegative && velocity.x != 0) yield Direction.right;
    if (!velocity.y.isNegative && velocity.y != 0) yield Direction.bottom;
  }

  bool _canMoveTo(
    Direction direction, {
    required GravityObject object,
    required int index,
  }) {
    final Vector2 position = object.position;
    final double maxPositionX = _getMaxPositionX(object.size);
    final double maxPositionY = _getMaxPositionY(object.size);

    switch (direction) {
      case Direction.left:
        if (position.x <= 0) return false;
      case Direction.top:
        if (position.y <= 0) return false;
      case Direction.right:
        if (position.x.round() >= maxPositionX.round()) return false;
      case Direction.bottom:
        if (position.y.round() >= maxPositionY.round()) return false;
    }

    return !isObjectCollidesAtDirection(direction, object: object, index: index);
  }
}
