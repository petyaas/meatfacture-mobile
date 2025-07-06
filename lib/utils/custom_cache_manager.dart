import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = 'customCache';

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 30), // Срок хранения кэша
            maxNrOfCacheObjects: 1000, // Максимальное количество объектов кэша
            fileService: HttpFileService(),
          ),
        );

  @override
  Future<FileInfo> downloadFile(
    String url, {
    String key,
    Map<String, String> authHeaders,
    bool force = false,
  }) async {
    final fileInfo = await super.downloadFile(
      url,
      key: key,
      authHeaders: authHeaders,
      force: force,
    );

    if (fileInfo != null && fileInfo.file.lengthSync() > 20 * 1024 * 1024) {
      // Удалить файл, если он больше 20 МБ
      await removeFile(key ?? url);
      return null;
    }

    return fileInfo;
  }
}
