import 'package:smart/services/services.dart';

class LoyaltyCardsListRepository {
  getLoyaltyCardsListFromRepository() async {
    LoyaltyCardsListProvider loyaltyCardsListProvider =
        LoyaltyCardsListProvider();
    return await loyaltyCardsListProvider.getLoyaltyCardsListResponse();
  }
}
