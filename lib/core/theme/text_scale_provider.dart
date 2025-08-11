import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/features/settings/presentation/providers/settings_provider.dart';

/// Provider that returns the text scale factor from settings
final textScaleFactorProvider = Provider<double>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.textScale;
});

/// Widget that applies the text scale factor to its child
class TextScaleWrapper extends ConsumerWidget {
  final Widget child;

  const TextScaleWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final textScale = ref.watch(textScaleFactorProvider) / 1.5;
    final textScale = 0.8;
    print('textScale: $textScale');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child,
    );
  }
}
