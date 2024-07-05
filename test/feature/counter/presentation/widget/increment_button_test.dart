import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_todo/feature/counter/presentation/widget/increment_button.dart';

abstract class IncrementHandler {
  void onIncrement(int value);
}

class MockIncrementHandler extends Mock implements IncrementHandler {}

void main() {
  testWidgets(
      'It should render button with add sign and be able to perform callback with increment input counter',
      (tester) async {
    final mockIncrementHanlder = MockIncrementHandler();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: IncrementButton(
            onIncrement: mockIncrementHanlder.onIncrement,
            counter: 1,
          ),
        ),
      )
    );

    expect(find.byTooltip('Increment'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    verifyNever(mockIncrementHanlder.onIncrement(2));

    await tester.tap(find.byTooltip('Increment'));

    verify(mockIncrementHanlder.onIncrement(2)).called(1);
  });
}
