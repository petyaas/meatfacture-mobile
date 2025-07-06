import 'package:smart/models/catalogs_model.dart';

class CatalogPagination {
  final List<CatalogsModel> catalogModelList;
  final int page;
  final String errorMessage;

  CatalogPagination({this.catalogModelList, this.page, this.errorMessage});
}
