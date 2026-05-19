import 'package:flutter_test/flutter_test.dart';

import 'package:buyo_piper_betle/src/app/buyo_app.dart';

void main() {
  testWidgets('Buyo landing page renders core content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BuyoApp());

    expect(find.text('BUYO'), findsOneWidget);
    expect(find.textContaining('AI-powered Buyo leaf disease'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.textContaining('Powered by Custom CNN'), findsOneWidget);
  });

  testWidgets('Get Started opens the home page', (WidgetTester tester) async {
    await tester.pumpWidget(const BuyoApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Good Morning'), findsOneWidget);
    expect(find.text('Scan Leaf'), findsOneWidget);
    expect(find.text('Upload Image'), findsOneWidget);
    expect(find.text('Recent Scans'), findsOneWidget);
  });
}
