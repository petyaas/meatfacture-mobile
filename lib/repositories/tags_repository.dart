import 'package:smart/services/services.dart';

class TagsRepository {
  TagsProvider _tagsProvider = TagsProvider();
  getAllTags() async => await _tagsProvider.getTags();
}
