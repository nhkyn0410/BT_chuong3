import 'package:bt_chuong3/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('completes the three-screen navigation flow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MovieExplorerApp());

    expect(find.text('MOVIE EXPLORER'), findsOneWidget);
    expect(find.text('Inception'), findsOneWidget);

    await tester.tap(find.text('EXPLORE'));
    await tester.pumpAndSettle();

    expect(find.text('FILM DETAILS'), findsOneWidget);
    expect(find.text('INCEPTION'), findsOneWidget);

    await tester.tap(find.text('Add to Watchlist'));
    await tester.pumpAndSettle();

    expect(find.text('ADDED TO WATCHLIST!'), findsOneWidget);

    await tester.tap(find.text('BACK TO HOME'));
    await tester.pumpAndSettle();

    expect(find.text('MOVIE EXPLORER'), findsOneWidget);
  });
}
