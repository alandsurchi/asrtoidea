import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_idea_generator/main.dart';

void main() {
  testWidgets('App smoke test renders root widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
