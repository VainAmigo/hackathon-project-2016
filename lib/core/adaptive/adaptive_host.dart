import 'package:flutter/foundation.dart';

/// Где запущено приложение: в браузере или как нативный клиент (iOS, Android, desktop).
enum AdaptiveHost {
  web,
  native,
}

AdaptiveHost resolveAdaptiveHost() =>
    kIsWeb ? AdaptiveHost.web : AdaptiveHost.native;
