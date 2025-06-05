import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:universal_platform/universal_platform.dart';

class StorageService {
  late final Isar _isar;
  
  Future<void> initialize() async {
    final dir = UniversalPlatform.isWeb
        ? null
        : await getApplicationDocumentsDirectory();
        
    _isar = await Isar.open(
      schemas: [
        CargaModelSchema,
        UserModelSchema,
        // ... otros schemas
      ],
      directory: dir?.path,
    );
  }

  Future<String> getPlatformSpecificPath() async {
    if (UniversalPlatform.isWeb) {
      return '';
    } else if (UniversalPlatform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      return dir?.path ?? '';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
  }
} 