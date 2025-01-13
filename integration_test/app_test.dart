import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_todo/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
          try {
            await dotenv.load(fileName: ".env");

            // Load app widget.
            await tester.pumpWidget(const MyApp());

            // Verify the counter starts at 0.
            expect(find.text('Counter'), findsOneWidget);

            await tester.tap(find.text('Counter'));

            // Trigger a frame.
            await tester.pumpAndSettle();

            // Finds the floating action button to tap on.
            final fab = find.byIcon(Icons.add);

            // Emulate a tap on the floating action button.
            await tester.tap(fab);

            // Trigger a frame.
            await tester.pumpAndSettle();

            // Verify the counter increments by 1.
            expect(find.text('Count Test: 1'), findsOneWidget);
          } catch (error) {
            binding.takeScreenshot('error');

            rethrow;
          }
    });
  });
}
