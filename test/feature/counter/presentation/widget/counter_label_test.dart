import 'package:flutter_test/flutter_test.dart';
import 'package:sample_todo/feature/counter/presentation/widget/counter_label.dart';

void main() {
  testWidgets('It should render text to inform user how many time they tap', (tester) async {
    await tester.pumpWidget(const CounterLabel(counter: 1));

    expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
