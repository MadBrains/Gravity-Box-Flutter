# gravity_box

A Flutter library that provides a GravityBox widget for simulating gravity inside of it.

This widget uses the [GravitySensor](https://pub.dev/packages/gravity_sensor) package to get the device's gravity sensor data.

## Features

- **Gravity Simulation**: Simulate gravity for widgets using the `GravityBox` widget.
- **Collision Detection**: Simple collision system between `GravityObject` and other children widgets.

## Usage

Import the package

```dart
import 'package:gravity_box/gravity_box.dart';
```


Use the widget.

```dart
GravityBox(
  gravityObjects: [
    GravityObject(
      size: 100,
      widget: Container(
        width: 42,
        height: 42,
        color: Colors.purple,
      ),
    ),
  ],
);
```


Provide a list of `GravityObject`s to the `gravityObjects` property. The `GravityBox` will automatically update the `GravityObject`s position and velocity based on the device's gravity sensor data.\
The `size` used to calculate bounding box of the object. Keep in mind that the size of the object is not the same as the size of the widget.\
The `position` is the top-left corner of the object in the `GravityBox` coordinate system (its layout contraints).\
If you want to add rolling ability (e.g. for circle-shaped widgets), set `canRoll: true` in the `GravityObject`.\
The `angle` is the current rotation degrees of the object.\
The `widget` is the widget that will be displayed as the object.\

```dart
GravityBox(
  gravityObjects: [
    GravityObject(
      size: 100,
      position: Vector2(50, 100),
      canRoll: true,
      angle: 90,
      widget: Container(
        width: 42,
        height: 42,
        color: Colors.purple,
      ),
    ),
  ],
);
```


To display debug info for the `GravityObject`, such as its position and borders, set `debugShowObjectsPosition: true` in the `GravityBox`.

```dart
GravityBox(
  debugShowObjectsPosition: true,
  gravityObjects: [
    GravityObject(
      child: Container(
        width: 42,
        height: 42,
        color: Colors.purple,
      ),
    ),
  ],
);
```


To display additional widgets in `GravityBox`, provide them in the `children` property if you want them to collide with `GravityObject`s and in the `notCollidableChildren` property if you want them to not collide with `GravityObject`s.

```dart
const GravityBox(
      notCollidableChildren: [
        Positioned.fill(
          child: ColoredBox(color: Color(0x80000000)),
        ),
      ],
      children: [FlutterLogo()],
    );
```

## Example

See full [Example][example] in the corresponding folder

[example]: https://github.com/MadBrains/Gravity-Box-Flutter/tree/main/example
