import 'package:flutter_test/flutter_test.dart';

import 'package:tsuper_app/app.dart';

void main() {
  testWidgets('navigates from splash to onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TsuperApp());

    expect(find.text('TSUPER'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
