import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaskita/app.dart';

void main() {
  testWidgets('Kaskita app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: KaskitaApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
