import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/services/services.dart';

class CatalogsRepository {
  final String catalogUuid;
  final int currentPage;

  CatalogsRepository({this.currentPage, this.catalogUuid});

  Future<List<CatalogListModel>> getCatalogsFromRepositoryforPagination() async {
    CatalogsProvider _catalogsProvider = CatalogsProvider(
      catalogUuid: catalogUuid != null ? catalogUuid : null,
      currentPage: currentPage,
    );
    return await _catalogsProvider.getCatalogsForPagination();
  }
}
