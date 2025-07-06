import 'package:smart/services/services.dart';

// Shopsrepository
class AddressesShopRepo {
  final String searchText;
  final bool hasParking;
  final bool hasReadyMeals;
  final bool hasAtms;
  final bool isfavorite;
  final bool isOpenNow;
  ShopsListProvider _shopsListProvider = ShopsListProvider();

  AddressesShopRepo({
    this.hasParking,
    this.hasReadyMeals,
    this.hasAtms,
    this.isfavorite,
    this.isOpenNow,
    this.searchText,
  });

  getAllShops() async => await _shopsListProvider.getShopsList(
        searchText: this.searchText,
        hasAtms: hasAtms,
        hasParking: hasParking,
        hasReadyMeals: hasReadyMeals,
        isOpenNow: isOpenNow,
        isfavorite: isfavorite,
      );
}
