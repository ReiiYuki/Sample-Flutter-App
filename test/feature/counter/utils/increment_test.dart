
import 'package:sample_todo/feature/counter/utils/increment.dart';
import 'package:test/test.dart';

void main() {
  test('It must perform increment input number by 1', () {
    expect(increment(1), 2);
  });
}
