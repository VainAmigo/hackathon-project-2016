import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_temp/core/di/injection_container.dart';
import 'package:project_temp/presentation/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies(testMode: true);
  });

  testWidgets('При старте открывается главная (вход не обязателен)', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    expect(find.text('Voice from the Archive'), findsOneWidget);
    expect(find.text('THE LIVING DOSSIER'), findsOneWidget);
  });
}
