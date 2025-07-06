import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/repositories/assortments_repository.dart';

abstract class AssortmentsListEvent {
  final String preCataloUuid;
  final uuidForAllProductsInCatalog;

  final List<String> brandName;
  String searchText;
  final bool isFavorite;
  final bool isPromoAssortment;
  final bool isRecommendations;
  final List<String> activeTagsList;
  final bool isAllSubcatalogsWithoutFavorite;
  String subcatalogUuid;

  AssortmentsListEvent({
    this.preCataloUuid,
    this.uuidForAllProductsInCatalog,
    this.brandName,
    this.searchText,
    this.isFavorite,
    this.isPromoAssortment,
    this.isRecommendations,
    this.activeTagsList,
    this.isAllSubcatalogsWithoutFavorite = false,
    this.subcatalogUuid,
  });
}

class AssortmentsListLoadEvent extends AssortmentsListEvent {
  AssortmentsListLoadEvent({
    String preCataloUuid,
    String uuidForAllProductsInCatalog,
    List<String> brandName,
    bool isFavorite,
    bool isPromoAssortment,
    bool isRecommendations,
    String searchText,
    List<String> activeTagsList,
    final bool isAllSubcatalogsWithoutFavorite,
    String subcatalogUuid,
  }) : super(
          preCataloUuid: preCataloUuid,
          uuidForAllProductsInCatalog: uuidForAllProductsInCatalog,
          brandName: brandName,
          isFavorite: isFavorite,
          isPromoAssortment: isPromoAssortment,
          isRecommendations: isRecommendations,
          activeTagsList: activeTagsList,
          searchText: searchText,
          isAllSubcatalogsWithoutFavorite: isAllSubcatalogsWithoutFavorite,
          subcatalogUuid: subcatalogUuid,
        );
}

class AssortmentsListNextPageEvent extends AssortmentsListEvent {
  AssortmentsListNextPageEvent({
    String preCataloUuid,
    String uuidForAllProductsInCatalog,
    List<String> brandName,
    bool isFavorite,
    bool isPromoAssortment,
    bool isRecommendations,
    String searchText,
    List<String> activeTagsList,
    String subcatalogUuid,
  }) : super(
          preCataloUuid: preCataloUuid,
          uuidForAllProductsInCatalog: uuidForAllProductsInCatalog,
          brandName: brandName,
          isFavorite: isFavorite,
          isPromoAssortment: isPromoAssortment,
          isRecommendations: isRecommendations,
          activeTagsList: activeTagsList,
          searchText: searchText,
          subcatalogUuid: subcatalogUuid,
        );
}

//states

abstract class AssortmentsListState {
  final List<AssortmentsListModel> assortmentsList;
  AssortmentsListState({@required this.assortmentsList});
}

class AssortmentsListInitState extends AssortmentsListState {
  AssortmentsListInitState() : super(assortmentsList: []);
}

class AssortmentsListLoadingState extends AssortmentsListState {
  AssortmentsListLoadingState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class AssortmentsListErrorState extends AssortmentsListState {
  AssortmentsListErrorState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class AssortmentsListEmptyState extends AssortmentsListState {
  AssortmentsListEmptyState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class AssortmentsListLoadedState extends AssortmentsListState {
  AssortmentsListLoadedState({
    @required List<AssortmentsListModel> assortmentsList,
  }) : super(
          assortmentsList: assortmentsList,
        );
}

class AssortmentsListBloc extends Bloc<AssortmentsListEvent, AssortmentsListState> {
  AssortmentsListBloc() : super(AssortmentsListInitState());
  List<AssortmentsListModel> assortmentsList = [];
  int currentPage = 1;
  int limit = 20;
  bool isAllLoaded = false;

  @override
  Stream<AssortmentsListState> mapEventToState(AssortmentsListEvent event) async* {
    if (event is AssortmentsListLoadEvent) {
      print('запрос дважды - ${event.isAllSubcatalogsWithoutFavorite}');
      currentPage = 1;
      assortmentsList = [];
      yield AssortmentsListLoadingState(assortmentsList: assortmentsList);
      try {
        assortmentsList = await AssortmentsRepository(
          isPromoAssortment: event.isPromoAssortment,
          uuidForAllProductsInCatalog: event.uuidForAllProductsInCatalog,
          activeTagsList: event.activeTagsList,
          brandName: event.brandName,
          isFavorite: event.isFavorite,
          isRecommendations: event.isRecommendations,
          searchText: event.searchText,
          currentPage: currentPage,
          catalogUuid: event.preCataloUuid,
        ).getAssortmentsFromRepositoryForPagination(
          isAllSubcatalogsWithoutFavorite: event.isAllSubcatalogsWithoutFavorite, //если дочерние есть должно приходить тру
          subcatalogUuid: event.subcatalogUuid,
        );
        print('listttt length ${assortmentsList.length}');
        if (assortmentsList.isNotEmpty) {
          yield AssortmentsListLoadedState(assortmentsList: assortmentsList);
        } else {
          yield AssortmentsListEmptyState(assortmentsList: assortmentsList);
        }
      } catch (e) {
        print("error in (assortmentsListBloc) class: $e )");
        yield AssortmentsListErrorState(assortmentsList: assortmentsList);
      }
    }

    if (event is AssortmentsListNextPageEvent) {
      if (!isAllLoaded) {
        //assortmentsList.length == limit * currentPage
        yield AssortmentsListLoadingState(assortmentsList: assortmentsList);
        currentPage++;
        try {
          final newList = await AssortmentsRepository(
            isPromoAssortment: event.isPromoAssortment,
            uuidForAllProductsInCatalog: event.uuidForAllProductsInCatalog,
            activeTagsList: event.activeTagsList,
            brandName: event.brandName,
            isFavorite: event.isFavorite,
            isRecommendations: event.isRecommendations,
            searchText: event.searchText,
            currentPage: currentPage,
            catalogUuid: event.preCataloUuid,
          ).getAssortmentsFromRepositoryForPagination();
          assortmentsList.addAll(newList);
          isAllLoaded = newList.isEmpty;

          yield AssortmentsListLoadedState(assortmentsList: assortmentsList);
        } catch (e) {
          print("error in (assortmentsListBloc) class: $e )");
          yield AssortmentsListErrorState(assortmentsList: assortmentsList);
        }
      }
    }
  }
}
