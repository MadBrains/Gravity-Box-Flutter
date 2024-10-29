import 'package:flutter/material.dart';
import 'package:gravity_box/gravity_box.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: GravityBox(
            debugShowObjectsPostion: true,
            gravityObjects: [
              GravityObject(
                size: 100,
                position: const Vector2(200, 200),
                canRoll: false,
                widget: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  width: 100,
                  height: 100,
                  child: Center(
                    child: Container(
                      color: Colors.indigo,
                      width: 100,
                      height: 10,
                    ),
                  ),
                ),
              ),
            ],
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.black,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.yellow,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.orange,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
