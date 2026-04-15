import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:worker_app_blc/main.dart';
import 'package:worker_app_blc/src/features/auth/application/auth_controller.dart';

void main() {
  testWidgets('Phone input screen renders on cold start', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter your phone'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
