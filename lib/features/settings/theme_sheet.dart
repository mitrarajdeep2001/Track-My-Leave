import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/db/app_database.dart';
import '../../data/providers.dart';

/// Bottom sheet for choosing the colour theme and light/dark mode.
/// Changes are saved and applied immediately.
class ThemeSheet extends ConsumerWidget {
  const ThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final s = ref.watch(settingsProvider).value;
    final selected = AppPalette.fromName(s?.themeColor);
    final mode = s?.themeMode ?? 'system';
    final db = ref.read(databaseProvider);
    final label = TextStyle(
      color: t.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      letterSpacing: 0.8,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme',
                style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Text('COLOUR', style: label),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final p in AppPalette.values)
                  _Swatch(
                    palette: p,
                    selected: p == selected,
                    onTap: () =>
                        db.updateSettings(AppSettingsCompanion(themeColor: Value(p.name))),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('MODE', style: label),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                      value: 'system', icon: Icon(Icons.brightness_auto), label: Text('System')),
                  ButtonSegment(
                      value: 'light', icon: Icon(Icons.light_mode_outlined), label: Text('Light')),
                  ButtonSegment(
                      value: 'dark', icon: Icon(Icons.dark_mode_outlined), label: Text('Dark')),
                ],
                selected: {mode},
                onSelectionChanged: (v) =>
                    db.updateSettings(AppSettingsCompanion(themeMode: Value(v.first))),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'System follows your phone\'s dark mode setting.',
              style: TextStyle(color: t.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.palette, required this.selected, required this.onTap});

  final AppPalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final scheme = ColorScheme.fromSeed(seedColor: palette.seed, brightness: t.brightness);
    return Semantics(
      button: true,
      selected: selected,
      label: '${palette.label} theme',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? scheme.primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [scheme.primary, scheme.tertiary],
                    ),
                  ),
                  child: selected ? Icon(Icons.check, color: scheme.onPrimary, size: 22) : null,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                palette.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? t.colorScheme.onSurface : t.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
