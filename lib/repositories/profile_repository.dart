import 'dart:developer';

import 'package:smart/services/services.dart';

class ProfileRepository {
  getProfileFromRepository() async {
    log('************* getProfileFromRepository *****************');
    ProfileProvider _profileProvider = ProfileProvider();
    return await _profileProvider.getProfileResponse();
  }
}
