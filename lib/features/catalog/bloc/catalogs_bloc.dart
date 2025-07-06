import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/features/catalog/repositories/catalogs_repository.dart';

abstract class CatalogsEvent {
  final String catalogUuid;
  CatalogsEvent({@required this.catalogUuid});
}

class CatalogsLoadEvent extends CatalogsEvent {
  CatalogsLoadEvent({String catalogUuid}) : super(catalogUuid: catalogUuid);
}

class CatalogstNextPageEvent extends CatalogsEvent {
  CatalogstNextPageEvent({String catalogUuid}) : super(catalogUuid: catalogUuid);
}

//states

abstract class CatalogsState {
  final List<CatalogListModel> catalogsList;
  CatalogsState({@required this.catalogsList});
}

class CatalogsInitState extends CatalogsState {
  CatalogsInitState() : super(catalogsList: []);
}

class CatalogsLoadingState extends CatalogsState {
  CatalogsLoadingState({@required List<CatalogListModel> catalogsList}) : super(catalogsList: catalogsList);
}

class CatalogsErrorState extends CatalogsState {
  CatalogsErrorState({@required List<CatalogListModel> catalogsList}) : super(catalogsList: catalogsList);
}

class CatalogsEmptyState extends CatalogsState {
  CatalogsEmptyState({@required List<CatalogListModel> catalogsList}) : super(catalogsList: catalogsList);
}

class CatalogsLoadedState extends CatalogsState {
  CatalogsLoadedState({@required List<CatalogListModel> catalogsList}) : super(catalogsList: catalogsList);
}

class CatalogsBloc extends Bloc<CatalogsEvent, CatalogsState> {
  CatalogsBloc() : super(CatalogsInitState());
  List<CatalogListModel> catalogsList = [];
  int currentPage = 1;
  int limit = 20;

  @override
  Stream<CatalogsState> mapEventToState(CatalogsEvent event) async* {
    if (event is CatalogsLoadEvent) {
      currentPage = 1;
      catalogsList = [];
      yield CatalogsLoadingState(catalogsList: catalogsList);
      try {
        catalogsList = await getCatalogsFromRepository(catalogUuid: event.catalogUuid);
        if (catalogsList.isNotEmpty) {
          yield CatalogsLoadedState(catalogsList: catalogsList);
        } else {
          yield CatalogsEmptyState(catalogsList: catalogsList);
        }
      } catch (e) {
        print("error in (CatalogsBloc) class: $e )");
        yield CatalogsErrorState(catalogsList: catalogsList);
      }
    }

    if (event is CatalogstNextPageEvent) {
      if (catalogsList.length == limit * currentPage) {
        yield CatalogsLoadingState(catalogsList: catalogsList);
        currentPage++;
        try {
          catalogsList.addAll(await getCatalogsFromRepository(catalogUuid: event.catalogUuid));
          yield CatalogsLoadedState(catalogsList: catalogsList);
        } catch (e) {
          print("error in (CatalogsBloc) class: $e )");
          yield CatalogsErrorState(catalogsList: catalogsList);
        }
      }
    }
  }

  Future<List<CatalogListModel>> getCatalogsFromRepository({String catalogUuid}) async {
    return await CatalogsRepository(currentPage: currentPage, catalogUuid: catalogUuid).getCatalogsFromRepositoryforPagination();
  }
}
