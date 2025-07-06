import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/services/services.dart';

class AssortmentsRepository {
  final String catalogUuid;
  final List<String> brandName;
  final uuidForAllProductsInCatalog;

  final String searchText;
  final bool isFavorite;
  final bool isRecommendations;
  final List<String> activeTagsList;
  final int currentPage;
  final bool isPromoAssortment;

  AssortmentsRepository({this.uuidForAllProductsInCatalog, this.brandName, this.isPromoAssortment, this.isRecommendations, this.isFavorite, this.currentPage, this.catalogUuid, this.searchText, this.activeTagsList});

  Future<List<AssortmentsListModel>> getAssortmentsFromRepositoryForPagination({
    bool isAllSubcatalogsWithoutFavorite = false,
    String subcatalogUuid,
  }) async {
    AssortmentsProvider _assortmentsProvider = AssortmentsProvider(
        uuidForAllProductsInCatalog: uuidForAllProductsInCatalog,
        isRecommendations: isRecommendations,
        brandName: brandName,
        isFavorite: isFavorite,
        isPromoAssortment: isPromoAssortment,
        catalogUuid: catalogUuid,
        currentPage: currentPage,
        searchText: searchText,
        activeTagsList: activeTagsList);
    return await _assortmentsProvider.getAssortmentsForPagination(
      isAllSubcatalogsWithoutFavorite: isAllSubcatalogsWithoutFavorite,
      subcatalogUuid: subcatalogUuid,
    );
  }
}
