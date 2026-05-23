import 'package:ballon_smash_adventure/app/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app theme builds with Material 3 enabled', () {
    final theme = buildAppTheme();

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, isNotNull);
  });
}
