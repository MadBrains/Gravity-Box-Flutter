import 'package:flutter/material.dart';
import 'package:gravity_box/src/models/models.dart';

/// {@template GravityObjectDebugWrapperWidget}
/// A widget that shows the debug info of a [GravityObject].
///
/// The widget will show the object's position and borders.
/// {@endtemplate}
class GravityObjectDebugWrapperWidget extends StatelessWidget {
  /// Creates a [GravityObjectDebugWrapperWidget].
  ///
  /// {@macro GravityObjectDebugWrapperWidget}
  const GravityObjectDebugWrapperWidget({
    super.key,
    required this.objectInfo,
    required this.child,
  });

  /// The [GravityObject] that is being debugged.
  final GravityObject objectInfo;

  /// The widget to be wrapped.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: child,
        ),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('x:'),
                  Text('y:'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(objectInfo.position.x.toStringAsFixed(2)),
                Text(objectInfo.position.y.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
