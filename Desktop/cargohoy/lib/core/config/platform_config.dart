import 'package:universal_platform/universal_platform.dart';

class PlatformConfig {
  static Map<String, dynamic> getPlatformSpecificSettings() {
    if (UniversalPlatform.isWeb) {
      return {
        'maxUploadSize': 10 * 1024 * 1024, // 10MB para web
        'cacheStrategy': 'memory',
        'apiTimeout': const Duration(seconds: 30),
      };
    } else if (UniversalPlatform.isDesktop) {
      return {
        'maxUploadSize': 100 * 1024 * 1024, // 100MB para desktop
        'cacheStrategy': 'disk',
        'apiTimeout': const Duration(minutes: 1),
        'windowSettings': {
          'minWidth': 800,
          'minHeight': 600,
          'defaultWidth': 1200,
          'defaultHeight': 800,
        },
      };
    } else {
      return {
        'maxUploadSize': 50 * 1024 * 1024, // 50MB para móvil
        'cacheStrategy': 'hybrid',
        'apiTimeout': const Duration(seconds: 45),
      };
    }
  }
}
