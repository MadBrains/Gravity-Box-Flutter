import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// {@template LayoutListener}
/// A widget that calls a [onContraintsChanged] callback
/// whenever the layout constraints change.
///
/// Useful for debugging or testing.
///
/// See also:
///
///  * [LayoutBuilder], which provides a way to build a widget tree
///    based on the parent widget's layout constraints.
///  {@endtemplate}
class LayoutListener extends SingleChildRenderObjectWidget {
  /// Creates a [LayoutListener].
  ///
  /// {@macro LayoutListener}
  const LayoutListener({
    super.key,
    required this.onContraintsChanged,
    super.child,
  });

  /// The callback that is called whenever the layout constraints change.
  ///
  /// The argument is the new [BoxConstraints].
  final ValueChanged<BoxConstraints> onContraintsChanged;

  @override
  RenderObject createRenderObject(context) {
    return _LayoutReporterRenderProxyBox(onContraintsChanged: onContraintsChanged);
  }
}

class _LayoutReporterRenderProxyBox extends RenderProxyBox {
  _LayoutReporterRenderProxyBox({
    required this.onContraintsChanged,
  });

  final ValueChanged<BoxConstraints> onContraintsChanged;

  BoxConstraints? _lastContraints;

  @override
  void performLayout() {
    if (_lastContraints == null) {
      onContraintsChanged(_lastContraints ??= constraints);
    }

    if (_lastContraints != constraints) {
      onContraintsChanged(constraints);
      _lastContraints = constraints;
    }

    return super.performLayout();
  }
}
