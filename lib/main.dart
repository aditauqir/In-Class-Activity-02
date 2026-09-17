import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RunMyApp());
}

// Special Feature 3: Custom ThemeExtension for app-specific design tokens.
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color avatarBackground;
  final Color avatarForeground;
  final Color statusBackground;
  final Color statusForeground;

  const AppColors({
    required this.success,
    required this.avatarBackground,
    required this.avatarForeground,
    required this.statusBackground,
    required this.statusForeground,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? avatarBackground,
    Color? avatarForeground,
    Color? statusBackground,
    Color? statusForeground,
  }) => AppColors(
    success: success ?? this.success,
    avatarBackground: avatarBackground ?? this.avatarBackground,
    avatarForeground: avatarForeground ?? this.avatarForeground,
    statusBackground: statusBackground ?? this.statusBackground,
    statusForeground: statusForeground ?? this.statusForeground,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      avatarBackground: Color.lerp(
        avatarBackground,
        other.avatarBackground,
        t,
      )!,
      avatarForeground: Color.lerp(
        avatarForeground,
        other.avatarForeground,
        t,
      )!,
      statusBackground: Color.lerp(
        statusBackground,
        other.statusBackground,
        t,
      )!,
      statusForeground: Color.lerp(
        statusForeground,
        other.statusForeground,
        t,
      )!,
    );
  }
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  // Special Feature 2: Load the saved theme mode from SharedPreferences.
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode');
    if (saved != null) {
      setState(() {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => ThemeMode.light,
        );
      });
    }
  }

  // Special Feature 2: Persist the selected theme mode with SharedPreferences.
  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }

  // Method to toggle the theme and persist the choice
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',

      // Special Feature 1: Material 3 themes with seed-generated color schemes.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
        extensions: const [
          AppColors(
            success: Color(0xFF2E7D32),
            avatarBackground: Colors.blueGrey,
            avatarForeground: Colors.white,
            statusBackground: Colors.amber,
            statusForeground: Colors.black,
          ),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        extensions: const [
          AppColors(
            success: Color(0xFF69F0AE),
            avatarBackground: Colors.teal,
            avatarForeground: Colors.white,
            statusBackground: Colors.teal,
            statusForeground: Colors.black,
          ),
        ],
      ),

      themeMode: _themeMode,

      // Special Feature 4: Animate the entire screen between ThemeData values.
      home: Builder(
        builder: (context) => AnimatedTheme(
          data: Theme.of(context),
          duration: const Duration(milliseconds: 500),
          child: Scaffold(
            appBar: AppBar(title: const Text('Status Card Demo')),
            body: Builder(
              builder: (context) {
                final bool isDark = _themeMode == ThemeMode.dark;
                final appColors = Theme.of(context).extension<AppColors>()!;

                // Part 1: Home screen uses a centered Column for the status card.
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Part 1: CircleAvatar and Flutter Theme Lab title.
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: appColors.avatarBackground,
                        child: Icon(
                          Icons.person,
                          size: 42,
                          color: appColors.avatarForeground,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Flutter Theme Lab',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Part 1: Required rounded status badge and dimensions.
                      Container(
                        width: 220,
                        height: 64,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: appColors.statusBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Part 2 Task 4: Change the status icon by theme.
                              Icon(
                                isDark
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: appColors.success,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status: Online',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: appColors.statusForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Choose the Theme:',
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      // Part 1: Theme control lets the user switch between themes.
                      // Part 2 Task 2: Switch control is wired to setState.
                      Switch(
                        value: isDark,
                        onChanged: (bool value) {
                          final newMode = value
                              ? ThemeMode.dark
                              : ThemeMode.light;
                          changeTheme(newMode);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
