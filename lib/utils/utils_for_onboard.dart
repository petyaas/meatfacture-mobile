import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';

class UtilsForOnboard {
  static Future cachImage(BuildContext context, String imageUrl) => precacheImage(AdvancedNetworkImage(imageUrl, useDiskCache: true, cacheRule: CacheRule(maxAge: const Duration(hours: 1))), context);
}
