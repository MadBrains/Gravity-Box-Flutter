import 'package:flutter_test/flutter_test.dart';
import 'package:gravity_box/gravity_box.dart';

void main() {
  testWidgets(
    'GravityBox() can be constructed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GravityBox(),
      );
    },
  );
}
