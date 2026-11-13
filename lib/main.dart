import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'data/providers.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  // Keep the native splash (logo + name) up until the first real screen is
  // ready, instead of flashing an empty frame while the database opens.
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(const ProviderScope(child: TrackMyLeaveApp()));
}

var _splashRemoved = false;

void _removeSplash() {
  if (_splashRemoved) return;
  _splashRemoved = true;
  WidgetsBinding.instance.addPostFrameCallback((_) => FlutterNativeSplash.remove());
}

class TrackMyLeaveApp extends ConsumerWidget {
  const TrackMyLeaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider).value;
    final palette = AppPalette.fromName(s?.themeColor);
    return MaterialApp(
      title: 'TrackMyLeave',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light, palette),
      darkTheme: buildTheme(Brightness.dark, palette),
      themeMode: themeModeFromName(s?.themeMode),
      home: const _Root(),
    );
  }
}

/// Shows onboarding until it is completed, then the app.
class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    if (!settings.isLoading) _removeSplash();
    return settings.when(
      loading: () => const _BrandedLoading(),
      error: (e, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not open the database.\n$e', textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (s) => s.onboardingDone ? const HomeShell() : const OnboardingScreen(),
    );
  }
}

/// Matches the native splash, in case the data takes longer than the splash.
class _BrandedLoading extends StatelessWidget {
  const _BrandedLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F766E),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.beach_access, size: 72, color: Colors.white),
            SizedBox(height: 16),
            Text('TrackMyLeave',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}
