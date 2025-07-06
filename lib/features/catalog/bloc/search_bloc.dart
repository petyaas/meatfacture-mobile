import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/assortments_list_model.dart';

abstract class SearchEvent {
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

  SearchEvent({
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

class SearchLoadEvent extends SearchEvent {
  SearchLoadEvent({
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

class SearchNextPageEvent extends SearchEvent {
  SearchNextPageEvent({
    String preCataloUuid,
    String uuidForAllProductsInCatalog,
    List<String> brandName,
    bool isFavorite,
    bool isPromoAssortment,
    bool isRecommendations,
    String searchText,
    List<String> activeTagsList,
  }) : super(
          preCataloUuid: preCataloUuid,
          uuidForAllProductsInCatalog: uuidForAllProductsInCatalog,
          brandName: brandName,
          isFavorite: isFavorite,
          isPromoAssortment: isPromoAssortment,
          isRecommendations: isRecommendations,
          activeTagsList: activeTagsList,
          searchText: searchText,
        );
}

//states

abstract class SearchState {
  final List<AssortmentsListModel> assortmentsList;
  SearchState({@required this.assortmentsList});
}

class SearchInitState extends SearchState {
  SearchInitState() : super(assortmentsList: []);
}

class SearchLoadingState extends SearchState {
  SearchLoadingState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class SearchErrorState extends SearchState {
  SearchErrorState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class SearchEmptyState extends SearchState {
  SearchEmptyState({@required List<AssortmentsListModel> assortmentsList}) : super(assortmentsList: assortmentsList);
}

class SearchLoadedState extends SearchState {
  SearchLoadedState({
    @required List<AssortmentsListModel> assortmentsList,
  }) : super(assortmentsList: assortmentsList);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitState());
  List<AssortmentsListModel> assortmentsList = [];
  int currentPage = 1;
  int limit = 20;
  bool isAllLoaded = false;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchLoadEvent) {
      currentPage = 1;
      assortmentsList = [];
      yield SearchLoadingState(assortmentsList: assortmentsList);
      try {
        log('fffffffffffffffffffffffffffffffff123');
        // assortmentsList = await AssortmentsRepository(
        //         isPromoAssortment: event.isPromoAssortment,
        //         uuidForAllProductsInCatalog: event.uuidForAllProductsInCatalog,
        //         activeTagsList: event.activeTagsList,
        //         brandName: event.brandName,
        //         isFavorite: event.isFavorite,
        //         isRecommendations: event.isRecommendations,
        //         searchText: event.searchText,
        //         currentPage: currentPage,
        //         catalogUuid: event.preCataloUuid)
        //     .getAssortmentsFromRepositoryForPagination(
        //   isAllSubcatalogsWithoutFavorite: event.isAllSubcatalogsWithoutFavorite, //если дочерние есть должно приходить тру
        //   subcatalogUuid: event.subcatalogUuid,
        // );
        if (assortmentsList.isNotEmpty) {
          yield SearchLoadedState(assortmentsList: assortmentsList);
        } else {
          yield SearchEmptyState(assortmentsList: assortmentsList);
        }
      } catch (e) {
        print("error in (assortmentsListBloc) class: $e )");
        yield SearchErrorState(assortmentsList: assortmentsList);
      }
    }

    if (event is SearchNextPageEvent) {
      if (!isAllLoaded) {
        //assortmentsList.length == limit * currentPage
        yield SearchLoadingState(assortmentsList: assortmentsList);
        currentPage++;
        try {
          // final newList = await AssortmentsRepository(
          //         isPromoAssortment: event.isPromoAssortment,
          //         uuidForAllProductsInCatalog: event.uuidForAllProductsInCatalog,
          //         activeTagsList: event.activeTagsList,
          //         brandName: event.brandName,
          //         isFavorite: event.isFavorite,
          //         isRecommendations: event.isRecommendations,
          //         searchText: event.searchText,
          //         currentPage: currentPage,
          //         catalogUuid: event.preCataloUuid)
          //     .getAssortmentsFromRepositoryForPagination();
          // assortmentsList.addAll(newList);
          // isAllLoaded = newList.isEmpty;

          yield SearchLoadedState(assortmentsList: assortmentsList);
        } catch (e) {
          print("error in (assortmentsListBloc) class: $e )");
          yield SearchErrorState(assortmentsList: assortmentsList);
        }
      }
    }
  }
}
