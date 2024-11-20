library;

import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'src/mixins/mixins.dart';
import 'src/models/models.dart';
import 'src/widgets/widgets.dart';

export 'src/models/models.dart';

/// {@template GravityBox}
/// A widget that enables gravity simulation for each of its [GravityObject].
///
/// Also provides a simple collision system between [GravityObject] and [children].
/// {@endtemplate}
class GravityBox extends StatefulWidget {
  /// Creates a [GravityBox].
  ///
  /// {@macro GravityBox}
  const GravityBox({
    super.key,
    this.gravityObjects = const [],
    this.children = const [],
    this.notCollidableChildren = const [],
    this.debugShowObjectsPostion = false,
  });

  /// The list of [GravityObject] that will be affected by gravity.
  ///
  /// See also [GravityObject].
  final List<GravityObject> gravityObjects;

  /// The list of widgets that will be collidable with [GravityObject].
  ///
  /// See also [notCollidableChildren].
  final List<Widget> children;

  /// The list of widgets that will not be collidable with [GravityObject].
  ///
  /// See also [children].
  final List<Widget> notCollidableChildren;

  /// If `true`, a small label will be shown at the top-left corner of each
  /// [GravityObject], displaying the object's current position and rect.
  ///
  /// Defaults to `false`.
  final bool debugShowObjectsPostion;

  @override
  State<GravityBox> createState() => _GravityBoxState();
}

class _GravityBoxState extends State<GravityBox>
    with SingleTickerProviderStateMixin, GravityInteractionMixin {
  late final Ticker _ticker;
  late final List<ValueNotifier<GravityObject>> _gravityObjectNotifiers =
      widget.gravityObjects.map((e) => ValueNotifier(e)).toList(growable: false);

  Set<Rect> _childrenRects = {};
  Duration _lastElapsedDuration = const Duration();

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    for (final ValueNotifier<GravityObject> valueNotifier in _gravityObjectNotifiers) {
      valueNotifier.dispose();
    }
    _ticker.dispose();

    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!canUpdate) return;

    final double dt =
        (elapsed - _lastElapsedDuration).inMicroseconds / Duration.microsecondsPerSecond;
    _lastElapsedDuration = elapsed;

    for (int i = 0; i < _gravityObjectNotifiers.length; i++) {
      final ValueNotifier<GravityObject> objectNotifier = _gravityObjectNotifiers[i];
      objectNotifier.value = updateObject(objectNotifier.value, dt, i);
    }
  }

  @override
  Widget childBuilder(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ...widget.notCollidableChildren,
        LayoutReporterStack(
          children: widget.children,
          onChildrenLayoutChanged: (childrenRects) => _childrenRects = childrenRects.toSet(),
        ),
        for (final ValueNotifier<GravityObject> gravityObjectNotifier in _gravityObjectNotifiers)
          ValueListenableBuilder(
            valueListenable: gravityObjectNotifier,
            builder: (_, GravityObject info, __) {
              final Widget object = Transform.rotate(
                angle: info.angle * (pi / 180),
                child: info.widget,
              );

              return Positioned(
                left: info.position.x,
                top: info.position.y,
                child: widget.debugShowObjectsPostion
                    ? GravityObjectDebugWrapperWidget(
                        objectInfo: info,
                        child: object,
                      )
                    : object,
              );
            },
          ),
      ],
    );
  }

  @override
  bool isObjectCollidesAtDirection(
    Direction direction, {
    required GravityObject object,
    required int index,
  }) {
    final bool isCollidingWithObjects = _gravityObjectNotifiers.indexed.any(
      (pair) {
        if (pair.$1 == index) return false;

        return _isObjectsColliding(direction, object, pair.$2.value);
      },
    );

    final bool isCollidingWithChildren =
        _childrenRects.any((e) => _isRectsColliding(direction, object.rect, e));

    return isCollidingWithObjects || isCollidingWithChildren;
  }

  Vector2 _getObjectPosition(
    Direction direction, {
    required GravityObject object,
  }) {
    final double radius = object.radius;
    final Vector2 position = object.position;

    return switch (direction) {
      Direction.left => Vector2(position.x, position.y + radius),
      Direction.top => Vector2(position.x + radius, position.y),
      Direction.right => Vector2(position.x + radius, position.y + radius),
      Direction.bottom => Vector2(position.x + radius, position.y + radius)
    };
  }

  Vector2 _getRectPosition(
    Direction direction, {
    required Rect rect,
  }) {
    return switch (direction) {
      Direction.left => Vector2(rect.left, rect.top + rect.height / 2),
      Direction.top => Vector2(rect.left + rect.width / 2, rect.top),
      Direction.right => Vector2(rect.left + rect.width, rect.top + rect.height / 2),
      Direction.bottom => Vector2(rect.left + rect.width / 2, rect.top + rect.height)
    };
  }

  bool _isInetervalsOverlaps(
    double aStart,
    double bStart,
    double aEnd,
    double bEnd,
  ) {
    if (aStart <= bStart) {
      return aStart + aEnd > bStart;
    } else {
      return bStart + bEnd > aStart;
    }
  }

  bool _isRectsColliding(
    Direction direction,
    Rect a,
    Rect b,
  ) {
    final Vector2 posA = _getRectPosition(direction, rect: a)..rounded;
    final Vector2 posB = _getRectPosition(direction.opposite, rect: b)..rounded;
    final bool isHorizontal = direction.isHorizontal;
    late double aStart;
    late double bStart;

    aStart = isHorizontal
        ? (posA.x - (direction.isRight ? a.width : 0))
        : (posA.y - (direction.isBottom ? a.height : 0));
    bStart = isHorizontal
        ? (posB.x - (direction.isLeft ? b.width : 0))
        : (posB.y - (direction.isTop ? b.height : 0));
    final bool notIntersected =
        direction.isLeft || direction.isTop ? aStart <= bStart : aStart >= bStart;
    if (notIntersected || !_isInetervalsOverlaps(aStart, bStart, a.width, b.width)) {
      return false;
    }
    aStart = isHorizontal ? posA.y - a.height / 2 : posA.x - a.width / 2;
    bStart = isHorizontal ? posB.y - b.height / 2 : posB.x - b.width / 2;

    return _isInetervalsOverlaps(
      aStart,
      bStart,
      isHorizontal ? a.height : a.width,
      isHorizontal ? b.height : b.width,
    );
  }

  bool _isObjectsColliding(
    Direction direction,
    GravityObject a,
    GravityObject b,
  ) {
    final Vector2 posA = _getObjectPosition(direction, object: a)..rounded;
    final Vector2 posB = _getObjectPosition(direction.opposite, object: b)..rounded;
    final bool isHorizontal = direction.isHorizontal;
    late double aStart;
    late double bStart;

    aStart = isHorizontal
        ? (posA.x - (direction.isRight ? a.size : 0))
        : (posA.y - (direction.isBottom ? a.size : 0));
    bStart = isHorizontal
        ? (posB.x - (direction.isLeft ? b.size : 0))
        : (posB.y - (direction.isTop ? b.size : 0));
    final bool notIntersected =
        direction.isLeft || direction.isTop ? aStart <= bStart : aStart >= bStart;
    if (notIntersected || !_isInetervalsOverlaps(aStart, bStart, a.size, b.size)) {
      return false;
    }
    aStart = isHorizontal ? posA.y - a.radius : posA.x - a.radius;
    bStart = isHorizontal ? posB.y - b.radius : posB.x - b.radius;

    return _isInetervalsOverlaps(aStart, bStart, a.size, b.size);
  }
}
