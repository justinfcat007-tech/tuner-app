import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuner_app/app/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TunerApp()));

    // Verify home screen shows TUNER title
    expect(find.text('TUNER'), findsOneWidget);
    expect(find.text('Tune with confidence, anywhere.'), findsOneWidget);
  });
}
