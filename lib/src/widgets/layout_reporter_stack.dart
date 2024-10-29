import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// {@template LayoutReporterStack}
/// A [Stack] that calls [onChildrenLayoutChanged] whenever the layout constraints change.
///
/// The [onChildrenLayoutChanged] callback is called with the layout constraints of all
/// the children in the stack. The constraints are given as a list of [Rect]s, where
/// each [Rect] represents the position and size of a single child.
/// {@endtemplate}
class LayoutReporterStack extends Stack {
  /// Creates a [LayoutReporterStack].
  ///
  /// {@macro LayoutReporterStack}
  const LayoutReporterStack({
    super.key,
    super.children,
    required this.onChildrenLayoutChanged,
  });

  /// The callback that is called when the layout constraints of the children change.
  ///
  /// The callback is called with a list of [Rect]s, where each [Rect] represents the
  /// position and size of a single child.
  final void Function(Iterable<Rect> childrenRects) onChildrenLayoutChanged;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _LayoutReporterRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
      onChildrenLayoutChanged: onChildrenLayoutChanged,
    );
  }
}

class _LayoutReporterRenderStack extends RenderStack {
  _LayoutReporterRenderStack({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    required this.onChildrenLayoutChanged,
  });

  final void Function(Iterable<Rect> childrenRects) onChildrenLayoutChanged;

  @override
  void paint(PaintingContext context, Offset offset) {
    onChildrenLayoutChanged(_getChildRects());

    return super.paint(context, offset);
  }

  Iterable<Rect> _getChildRects() sync* {
    RenderBox? child = firstChild;

    while (child != null) {
      final StackParentData? childParentData = child.parentData as StackParentData?;

      if (!child.hasSize) {
        child = childParentData?.nextSibling;

        continue;
      }

      if (child is RenderPositionedBox) {
        final Alignment? alignment =
            child.alignment is Alignment ? (child.alignment as Alignment) : null;
        final Size size = child.child?.size ?? child.size;

        final double width = size.width.isFinite ? size.width : constraints.maxWidth;
        final double height = size.height.isFinite ? size.height : constraints.maxHeight;

        final rect = Rect.fromLTWH(
          alignment == null ? 0 : _lerp(alignment.x, width, constraints.maxWidth),
          alignment == null ? 0 : _lerp(alignment.y, height, constraints.maxHeight),
          width,
          height,
        );

        yield rect;
      } else {
        final Offset? offset = childParentData?.offset;
        final Size size = child.size;

        yield Rect.fromLTWH(
          offset?.dx ?? 0,
          offset?.dy ?? 0,
          size.width.isFinite ? size.width : constraints.maxWidth,
          size.height.isFinite ? size.height : constraints.maxHeight,
        );
      }

      child = childParentData?.nextSibling;
    }
  }

  double _lerp(double alignment, double size, double maxSize) {
    if (alignment == 0) return maxSize / 2 - size / 2;

    if (alignment > 0) {
      return (maxSize - size) * alignment;
    } else {
      return (-maxSize + size) * (1 + alignment);
    }
  }
}
