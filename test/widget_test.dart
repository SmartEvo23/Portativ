import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portativ/app.dart';

void main() {
  testWidgets('App pornește și afișează loader-ul inițial fără să crape', (WidgetTester tester) async {
    // Testul implicit generat de Flutter (contor "+") nu are nicio legătură cu
    // Portativ - aplicația nu are un contor. Verificăm doar că App() se
    // construiește fără erori și arată loader-ul afișat înainte ca
    // AuthenticationRepository să decidă spre ce ecran navighează.
    await tester.pumpWidget(const App());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
