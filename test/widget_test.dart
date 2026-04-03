import 'package:flutter_test/flutter_test.dart';

import 'package:project_temp/core/di/injection_container.dart';
import 'package:project_temp/presentation/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initDependencies(testMode: true);
  });

  testWidgets('Без токена показывается экран входа', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    expect(find.text('Войти'), findsOneWidget);
    expect(find.text('Телефон'), findsOneWidget);
  });
}
