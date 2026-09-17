import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_card_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Status Card App test - Features 1, 2, and 3', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const RunMyApp());
    await tester.pumpAndSettle();

    // Verify avatar, title, status text, and switch exist.
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('Flutter Theme Lab'), findsOneWidget);
    expect(find.text('Status: Online'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Initial Light Theme state:
    final Switch initialSwitch = tester.widget(find.byType(Switch));
    expect(initialSwitch.value, false);

    final CircleAvatar lightAvatar = tester.widget(find.byType(CircleAvatar));
    expect(lightAvatar.radius, 45);
    expect(lightAvatar.backgroundColor, Colors.blueGrey);

    final Container lightBadge = tester.widget(find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration as BoxDecoration).borderRadius != null));
    final BoxDecoration lightBadgeDec = lightBadge.decoration as BoxDecoration;
    expect(lightBadgeDec.color, Colors.amber);

    // Task 4: In light mode, icon is circle_outlined
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);

    // Feature 3: Check light theme extension AppColors
    final BuildContext context = tester.element(find.byType(Scaffold));
    final lightAppColors = Theme.of(context).extension<AppColors>();
    expect(lightAppColors, isNotNull);
    expect(lightAppColors!.success, const Color(0xFF2E7D32));

    // Toggle Switch to Dark Mode
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final Switch darkSwitch = tester.widget(find.byType(Switch));
    expect(darkSwitch.value, true);

    final CircleAvatar darkAvatar = tester.widget(find.byType(CircleAvatar));
    expect(darkAvatar.backgroundColor, Colors.teal);

    final Container darkBadge = tester.widget(find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration as BoxDecoration).borderRadius != null));
    final BoxDecoration darkBadgeDec = darkBadge.decoration as BoxDecoration;
    expect(darkBadgeDec.color, Colors.teal);

    // Task 4: In dark mode, icon is check_circle
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsNothing);

    // Feature 3: Check dark theme extension AppColors
    final BuildContext darkContext = tester.element(find.byType(Scaffold));
    final darkAppColors = Theme.of(darkContext).extension<AppColors>();
    expect(darkAppColors, isNotNull);
    expect(darkAppColors!.success, const Color(0xFF69F0AE));

    // Feature 2: Verify SharedPreferences saved 'dark'
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('themeMode'), 'dark');

    // Toggle Switch back to Light Mode
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    final Switch switchedBack = tester.widget(find.byType(Switch));
    expect(switchedBack.value, false);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
    expect(prefs.getString('themeMode'), 'light');
  });
}
