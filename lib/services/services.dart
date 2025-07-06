import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/bloc_files/order_created_bloc.dart';
import 'package:smart/core/constants/shared_keys.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_list_model.dart';
import 'package:smart/features/addresses/addresses_shop/models/addresses_shop_model.dart';
import 'package:smart/features/home/models/banners_list_model.dart';
import 'package:smart/features/profile/models/profile_model.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/main.dart';
import 'package:smart/models/assortment_brands_list_model.dart';
import 'package:smart/models/assortment_comments_model.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/models/assortments_model.dart';
import 'package:smart/features/basket/models/basket_list_model.dart';
import 'package:smart/models/bonuses_list_model.dart';
import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/models/catalogs_model.dart';
import 'package:smart/models/check_details_model.dart';
import 'package:smart/models/check_details_products_model.dart';
import 'package:smart/features/addresses/addresses_delivery/models/address_client_model.dart';
import 'package:smart/models/create_order_response_model.dart';
import 'package:smart/models/credit_cards_list_model.dart';
import 'package:smart/models/delete_profile_model.dart';
import 'package:smart/models/diverse_food_assortment_list_model.dart';
import 'package:smart/models/diverse_food_future_discount_model.dart';
import 'package:smart/models/diverse_food_persent_list_model.dart';
import 'package:smart/models/diverse_food_present_discount_model.dart';
import 'package:smart/models/diverse_food_stats_model.dart';
import 'package:smart/features/fav_product/models/favorite_product_model.dart';
import 'package:smart/models/favorite_product_title_model.dart';
import 'package:smart/models/favorite_product_variant_uuid_model.dart';
import 'package:smart/models/geocoding_model.dart';
import 'package:smart/models/get_token_response_model.dart';
import 'package:smart/models/im_in_shop_model.dart';
import 'package:smart/models/loyalty_cards_list_model.dart';
import 'package:smart/models/notification_list_model.dart';
import 'package:smart/models/onboarding_list_Model.dart';
import 'package:smart/models/order_calculate_response_model.dart';
import 'package:smart/models/order_list_model.dart';
import 'package:smart/models/prodmo_descriptions_model.dart';
import 'package:smart/models/product_details_model.dart';
import 'package:smart/models/product_model_for_order_request.dart';
import 'package:smart/models/purchases_sum_model.dart';
import 'package:smart/models/recomendation_list_model.dart';
import 'package:smart/models/shopping_check_list_data_model.dart';
import 'package:smart/models/shopping_check_list_model.dart';
import 'package:smart/models/shopping_list_deatils_model.dart';
import 'package:smart/models/shopping_lists_model.dart';
import 'package:smart/models/single_recipe_data_model.dart';
import 'package:smart/models/smart_contacts_model.dart';
import 'package:smart/models/socials_list_model.dart';
import 'package:smart/models/stories_list_model.dart';
import 'package:smart/models/tags_model.dart';
import 'package:smart/models/unique_sections_model.dart';
import 'package:smart/models/url_for_credit_carde_link_model.dart';
import 'package:smart/models/vacancy_list_model.dart';
import 'package:smart/order_process/order_process_list_model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

// FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

String apiHead = //"https://api.s-mart.su";
// "https://api.kprg.alldemo.ru";
    // "https://mobile.prg.wearefullstack.ru"
    "https://api.myasofaktura.ru";

class OrderProcessProvider {
  String _orderProcessListUrl;

  Future<OrderProcessListModel> orderProcessResponse() async {
    String token = await loadToken();
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // String token2 = "9b4b9170-c94f-46df-acd4-286c81e3d943";
    _orderProcessListUrl =
        "$apiHead/clients/api/profile/orders?order_by[number]=desc&api_token=$token&where[0][0]=order_status_id&where[0][1]=not in&where[0][2][0]=done&where[0][2][1]=cancelled&where[1][0]=planned_delivery_datetime_from&where[1][1]=like&where[1][2]=$formattedDate%";
    final respone = await http.get(
      Uri.parse(_orderProcessListUrl),
      headers: {"Accept": "application/json"},
    );
    log('url:: get Future<OrderProcessListModel> orderProcessResponse ' + _orderProcessListUrl);
    print('✅ ${respone.body}');
    if (respone.statusCode == 200) {
      final Map<String, dynamic> orderProcessListJson = json.decode(respone.body);
      return OrderProcessListModel.fromJson(orderProcessListJson);
    } else {
      throw Exception("Ошибка. ❌ Данные о заказах не прогружены");
    }
  }
}

//Vacancy list
class VacancyListProvider {
  String _vacancyListUrl = "$apiHead/clients/api/vacancy";

  Future<VacancyListModel> getVacancyListResponse({@required int page}) async {
    String _token = await loadToken();
    _vacancyListUrl += "?api_token=$_token&page=$page";

    final response = await http.get(
      Uri.parse(_vacancyListUrl),
      headers: {"Accept": "application/json"},
    );
    log('get ' + _vacancyListUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _vacancyListJson = json.decode(response.body);
      return VacancyListModel.fromJson(_vacancyListJson);
    } else {
      throw Exception("error  fetching vacancy list!");
    }
  }
}

//bonuses List
class BonusesListProvider {
  BonusesListProvider();

  Future<List<BonusesListDataModel>> BonusesListForPaginationResponse({@required int currentPage}) async {
    String token = await loadToken();
    String url =
        "$apiHead/clients/api/profile/client-bonus-transactions?api_token=$token&order_by[created_at]=desc&page=$currentPage";
    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    log('get ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> bonusesListJson = json.decode(response.body);
      return BonusesListModel.fromJson(bonusesListJson).data;
    } else {
      throw Exception('Error bonuses List!!!');
    }
  }
}

// onborading list
class OnboardingListProvider {
  String _onboardingListUrl = "$apiHead/clients/api/onboarding";

  Future<OnboardingListModel> getOnboradingListResponse() async {
    // String _token = await loadToken();
    _onboardingListUrl += "?per_page=100";
    final response = await http.get(
      Uri.parse(_onboardingListUrl),
      headers: {"Accept": "application/json"},
    );
    log('getOnboradingListResponse ' + _onboardingListUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _onboardingListJson = json.decode(response.body);
      return OnboardingListModel.fromJson(_onboardingListJson);
    } else {
      throw Exception("error  fetching onborading list!");
    }
  }
}

class BannersProvider {
  String _bannersListUrl;

  Future<BannersListModel> bannersResponse() async {
    _bannersListUrl =
        "$apiHead/clients/api/banners?where[0][0]=enabled&where[0][1]=%3D&where[0][2]=t&per_page=100&order_by[number]=asc";
    final respone = await http.get(
      Uri.parse(_bannersListUrl),
      headers: {"Accept": "application/json"},
    );
    log('get Future<BannersListModel> bannersResponse ' + _bannersListUrl);
    if (respone.statusCode == 200) {
      final Map<String, dynamic> bannersListJson = json.decode(respone.body);
      return BannersListModel.fromJson(bannersListJson);
    } else {
      throw Exception("Ошибка при получении данных баннеров");
    }
  }
}

class StoriesProvider {
  String _storiesListUrl;

  Future<StoriesListModel> storiesResponse() async {
    String token = await loadToken();
    _storiesListUrl = "$apiHead/clients/api/stories?order_by[created_at]=asc&api_token=$token&per_page=1000";
    final respone = await http.get(
      Uri.parse(_storiesListUrl),
      headers: {"Accept": "application/json"},
    );
    log('get Future<StoriesListModel> storiesResponse ' + _storiesListUrl);
    if (respone.statusCode == 200) {
      final Map<String, dynamic> storiesListJson = json.decode(respone.body);
      return StoriesListModel.fromJson(storiesListJson);
    } else {
      throw Exception("error fetching stories list!!!");
    }
  }
}

//Client Addresses
class AddressesClientProvider {
  String _clienAddressUrl = "$apiHead/clients/api/profile/delivery-addresses";

  Future<AddressesClientListModel> clientAddressResponse() async {
    String token = await loadToken();
    _clienAddressUrl += "?api_token=$token";
    _clienAddressUrl += "&order_by[updated_at]=desc";

    log('url:: 🏠 получаем сохраненные адреса клиента get Future<ClientAddressModel>clientAddressResponse: ' +
        _clienAddressUrl);

    final response = await http.get(
      Uri.parse(_clienAddressUrl),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> clientAddressJson = json.decode(response.body);
      AddressesClientListModel model = AddressesClientListModel.fromJson(clientAddressJson);
      print('ClientAddressModel:::: ${model.data}');
      if (model.data.isNotEmpty) {
        await prefs.setString(
            SharedKeys.myAddress, '${model.data[0].city}, ${model.data[0].street} ${model.data[0].house}');
        await prefs.setString(SharedKeys.myAddressUuid, model.data[0].uuid);
      }
      return model;
    } else {
      throw Exception("error fetching client address list!!!");
    }
  }

  Future<bool> addClientAddressResponse(
      {String title,
      String city,
      String street,
      String house,
      String floor,
      String entrance,
      String apartmentNumber,
      String intercomCode}) async {
    String token = await loadToken();
    _clienAddressUrl += "?api_token=$token";
    final response = await http.post(Uri.parse(_clienAddressUrl), headers: {
      "Accept": "application/json"
    }, body: {
      if (title != null && title.isNotEmpty) "title": title,
      if (entrance != null && entrance.isNotEmpty) "entrance": entrance,
      if (city != null && city.isNotEmpty) "city": city,
      if (street != null && street.isNotEmpty) "street": street,
      if (house != null && house.isNotEmpty) "house": house,
      if (floor != null && floor.isNotEmpty) "floor": floor,
      if (apartmentNumber != null && apartmentNumber.isNotEmpty) "apartment_number": apartmentNumber,
      if (intercomCode != null && intercomCode.isNotEmpty) "intercom_code": intercomCode,
    });
    log('Cохраняем адрес клиента 🏠 post addClientAddressResponse: ' + _clienAddressUrl);
    if (title != null && title.isNotEmpty) print('title👉 ' + title);
    if (entrance != null && entrance.isNotEmpty) print('entrance:: ' + entrance);
    if (city != null && city.isNotEmpty) print('city:: ' + city);
    if (street != null && street.isNotEmpty) print('street:: ' + street);
    if (house != null && house.isNotEmpty) print('house:: ' + house);
    if (floor != null && floor.isNotEmpty) print('floor:: ' + floor);
    if (apartmentNumber != null && apartmentNumber.isNotEmpty) print('apartment_number:: ' + apartmentNumber);
    if (intercomCode != null && intercomCode.isNotEmpty) print('intercom_code:: ' + intercomCode);
    if (response.statusCode == 201) {
      // final Map<String, dynamic> clientAddressJson = json.decode(response.body);
      return true;
    } else {
      if (response.statusCode == 422) {
        (Fluttertoast.showToast(msg: "wrongAddressDataText".tr()));
      }
      return false;
    }
  }

  Future<bool> changeClientAddressResponse({
    @required String addressUuid,
    String title,
    String city,
    String street,
    String house,
    String floor,
    String entrance,
    String apartmentNumber,
    String intercomCode,
  }) async {
    String token = await loadToken();
    _clienAddressUrl += "/{$addressUuid}?api_token=$token";

    final response = await http.put(Uri.parse(_clienAddressUrl), headers: {
      "Accept": "application/json"
    }, body: {
      if (title != null && title != "null" && title.isNotEmpty) "title": title,
      if (city != null && city != "null" && city.isNotEmpty) "city": city,
      if (street != null && street != "null" && street.isNotEmpty) "street": street,
      if (house != null && house != "null" && house.isNotEmpty) "house": house,
      if (floor != null && floor != "null" && floor.isNotEmpty) "floor": floor,
      if (apartmentNumber != null && apartmentNumber != "null" && apartmentNumber.isNotEmpty)
        "apartment_number": apartmentNumber,
      if (entrance != null && entrance != "null" && entrance.isNotEmpty) "entrance": entrance,
      if (intercomCode != null && intercomCode != "null" && intercomCode.isNotEmpty) "intercom_code": intercomCode,
    });
    log('Обновляем адрес клиента 🏠♻️ put changeClientAddressResponse: ' + _clienAddressUrl);
    if (title != null && title != "null" && title.isNotEmpty) print('title👉 ' + title);
    if (city != null && city != "null" && city.isNotEmpty) print('city:: ' + city);
    if (street != null && street != "null" && street.isNotEmpty) print('street:: ' + street);
    if (house != null && house != "null" && house.isNotEmpty) print('house:: ' + house);
    if (floor != null && floor != "null" && floor.isNotEmpty) print('floor:: ' + floor);
    if (apartmentNumber != null && apartmentNumber != "null" && apartmentNumber.isNotEmpty)
      print('apartment_number:: ' + apartmentNumber);
    if (entrance != null && entrance != "null" && entrance.isNotEmpty) print('entrance:: ' + entrance);
    if (intercomCode != null && intercomCode != "null" && intercomCode.isNotEmpty)
      print('intercom_code:: ' + intercomCode);
    if (response.statusCode == 200) {
      // final Map<String, dynamic> clientAddressJson = json.decode(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<bool> deleteClientAddressResponse({@required String addressId}) async {
    String token = await loadToken();
    _clienAddressUrl += "/{$addressId}?api_token=$token";
    final response = await http.delete(Uri.parse(_clienAddressUrl), headers: {"Accept": "application/json"});
    log('удаляем адрес клиента 🏠 delete ClientAddressResponse ' + _clienAddressUrl);
    if (response.statusCode == 200) {
      // final Map<String, dynamic> clientAddressJson = json.decode(response.body);
      return true;
    } else {
      return false;
    }
  }
}

//Бренды товаров
class AssortmentBrandsProvider {
  //TODO1 heart
  String _assortBrandsUrl = "$apiHead/clients/api/assortment-brands";

  Future<AssortmentBrandsListmodel> getAssortmentBrandsResponse({@required int page, String searchText}) async {
    String token = await loadToken();
    _assortBrandsUrl += "?api_token=$token&page=$page&order_by[name] = asc";
    if (searchText != null) {
      _assortBrandsUrl += "&where[0][0]=name&where[0][1]=ilike&where[0][2]=%$searchText%";
    }
    final response = await http.get(Uri.parse(_assortBrandsUrl), headers: {"Accept": "application/json"});
    log('getAssortmentBrandsResponse get ' + _assortBrandsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _assortmentBrandsListJson = json.decode(response.body);
      return AssortmentBrandsListmodel.fromJson(_assortmentBrandsListJson);
    } else {
      throw Exception("error to fetching brands list");
    }
  }
}

//для акции "Я в магазине"
class ImInShopProvider {
  String imInShopUrl = "$apiHead/clients/api/profile/promotion/in-the-shop";
  Future<ImInShopModel> getImInShopListResponse() async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    imInShopUrl += "?api_token=$token&store_uuid=$shopUuid";
    final response = await http.get(
      Uri.parse(imInShopUrl),
      headers: {"Accept": "application/json"},
    );
    log('get ' + imInShopUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _iminShopJson = json.decode(response.body);
      return ImInShopModel.fromJson(_iminShopJson);
    } else {
      throw Exception("error to fetching im in shop list. StatusCode: ${response.statusCode}");
    }
  }

  Future<String> turnOnImInShop() async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    if (shopUuid == null || shopUuid == "") {
      return "notStoreChoose";
    }
    final response = await http.post(Uri.parse(imInShopUrl),
        body: {"store_uuid": shopUuid, "api_token": token}, headers: {"Accept": "application/json"});
    log('post turnOnImInShop:::::::::: ' + imInShopUrl);
    print('store_uuid:: ' + shopUuid);
    print('api_token:: ' + token);
    if (response.statusCode == 204 || response.statusCode == 400) {
      return "true";
    } else if (response.statusCode == 401) {
      return "old token";
    } else {
      return "false";
    }
  }
}

//всё для кредитный карт
class CreditCardsProvider {
  String creditCardsUrl = "$apiHead/clients/api/profile/credit-cards";
  Future<CreditCardsListModel> getCreditCardsListResponce() async {
    String token = await loadToken();
    creditCardsUrl += "?api_token=$token";
    final response = await http.get(Uri.parse(creditCardsUrl), headers: {"Accept": "application/json"});
    log('💳 get:: ' + creditCardsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _creditCardsListJson = json.decode(response.body);
      return CreditCardsListModel.fromJson(_creditCardsListJson);
    } else if (response.statusCode == 401) {
      return CreditCardsListModel();
    } else {
      throw Exception("error to fetching credit cards list");
    }
  }

  Future<bool> deleteCreditCardResponse({@required String cardUuid}) async {
    String token = await loadToken();
    creditCardsUrl += "/{$cardUuid}?api_token=$token";
    final response = await http.delete(Uri.parse(creditCardsUrl), headers: {"Accept": "application/json"});
    log('💳 delete:: ' + creditCardsUrl);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<UrlForCreditCardLinkModel> getUrlForCreditCardLinkResponse() async {
    String token = await loadToken();
    creditCardsUrl += "/link?api_token=$token";
    final response = await http.get(Uri.parse(creditCardsUrl), headers: {"Accept": "application/json"});
    log('💳 get:: ' + creditCardsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _urlForCreditCardLinkJson = json.decode(response.body);
      return UrlForCreditCardLinkModel.fromJson(_urlForCreditCardLinkJson);
    } else {
      throw Exception("error fetching url for card ");
    }
  }

  Future<bool> setSuccessStatusOfLinkingCardResponse({@required String orderId}) async {
    String token = await loadToken();
    creditCardsUrl += "/link/success?api_token=$token&orderId=$orderId";
    final response = await http.get(Uri.parse(creditCardsUrl), headers: {"Accept": "application/json"});
    log('💳 get setSuccessStatusOfLinkingCardResponse:: ' + creditCardsUrl);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setSErrorStatusOfLinkingCardResponse({@required String orderId}) async {
    String token = await loadToken();
    creditCardsUrl += "/link/error?api_token=$token&orderId=$orderId";
    final response = await http.get(Uri.parse(creditCardsUrl), headers: {"Accept": "application/json"});
    log('💳 get setSErrorStatusOfLinkingCardResponse:: ' + creditCardsUrl);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}

//Описание акций
class PromoDescriptionsProvider {
  String promoDescriptionsUrl = "$apiHead/clients/api/promo-descriptions";
  Future<List<PromoDescriptionsDataModel>> getPromoDescriptionsResponse(int page) async {
    String token = await loadToken();
    promoDescriptionsUrl += "?where[0][0]=is_hidden&where[0][1]==&where[0][2]=false&api_token=$token&page=$page";
    final response = await http.get(Uri.parse(promoDescriptionsUrl), headers: {"Accept": "application/json"});
    log('get getPromoDescriptionsResponse ::::: ' + promoDescriptionsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _promoDescriptionsJson = json.decode(response.body);
      return PromoDescriptionsModel.fromJson(_promoDescriptionsJson).data;
    } else {
      throw Exception("error fetching promo descriptions");
    }
  }

  Future<PromoDescriptionsDataModel> getDiverseFoodDescriptionsResponse() async {
    String token = await loadToken();
    promoDescriptionsUrl += "?where[0][0]=name&where[0][1]==&where[0][2]=Разнообразное питание&api_token=$token";
    final response = await http.get(Uri.parse(promoDescriptionsUrl), headers: {"Accept": "application/json"});
    log('get getDiverseFoodDescriptionsResponse :::: ' + promoDescriptionsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _promoDescriptionsJson = json.decode(response.body);
      return PromoDescriptionsModel.fromJson(_promoDescriptionsJson).data.first;
    } else {
      throw Exception("error fetching promo descriptions");
    }
  }

  Future<FavoriteProductTitleModel> favoritePrductTitleRequest() async {
    String token = await loadToken();
    promoDescriptionsUrl += "?api_token=$token&where[0][0]=name&where[0][1]==&where[0][2]=Любимый продукт";
    final response = await http.get(Uri.parse(promoDescriptionsUrl), headers: {"Accept": "application/json"});
    log('favoritePrductTitleRequest:: get ' + promoDescriptionsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _promoDescriptionsJson = json.decode(response.body);
      return FavoriteProductTitleModel.fromJson(_promoDescriptionsJson);
    } else {
      throw Exception("error fetching promo descriptions. StatusCode: ${response.statusCode}");
    }
  }
}

//get contacts
class SmartContactsProvider {
  String _url;
  Future<SmartContactsModel> getContactsResponse() async {
    _url = "$apiHead/clients/api/contacts";
    String token = await loadToken();
    _url += "?api_token=$token";
    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    log('getContactsResponse:: get ' + _url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _contactJson = json.decode(response.body);
      return SmartContactsModel.fromJson(_contactJson);
    } else {
      throw Exception("error fetching Meatfacture contacts");
    }
  }

  Future<SocialsListModel> getSocialsListResponse() async {
    _url = "$apiHead/clients/api/social";
    String token = await loadToken();
    _url += "?api_token=$token";
    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    log('getSocialsListResponse:: get ' + _url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _contactJson = json.decode(response.body);
      return SocialsListModel.fromJson(_contactJson);
    } else {
      throw Exception("error fetching socials contacts");
    }
  }
}

//класс геокодинга
class GeocodingProvider {
  String geocodingUrl;

  Future<GeocodingModel> getGeocodingReverseResponse({@required Point latLng}) async {
    String token = await loadToken();
    geocodingUrl =
        "$apiHead/clients/api/geocode/reverse?api_token=$token&longitude=${latLng.longitude}&latitude=${latLng.latitude}";
    final response = await http.get(
      Uri.parse(geocodingUrl),
      headers: {"Accept": "application/json"},
    );
    log('getGeocodingReverseResponse:: get ' + geocodingUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _geocodingModelJson = json.decode(response.body);
      return GeocodingModel.fromJson(_geocodingModelJson);
    } else {
      throw Exception("Geocoding Error");
    }
  }

  Future<GeocodingModel> getGeocodingResponse({@required String address}) async {
    String token = await loadToken();
    geocodingUrl = "$apiHead/clients/api/geocode?api_token=$token&address=$address";
    final response = await http.get(Uri.parse(geocodingUrl), headers: {"Accept": "application/json"});
    log('getGeocodingResponse:: get ' + geocodingUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> _geocodingModelJson = json.decode(response.body);
      return GeocodingModel.fromJson(_geocodingModelJson);
    } else {
      throw Exception("Geocoding Error");
    }
  }
}

//Diverse food
class DiverseFoodProvider {
  String _diverseFoodUrl = "$apiHead/clients/api/profile/promo-diverse-food-";

  Future<DiverseFoodPersentListModel> getImInShopPersentListModelResponse() async {
    String token = await loadToken();

    String diverseFoodUrl = "$apiHead/clients/api/promo-diverse-food-settings?api_token=$token";
    final response = await http.get(
      Uri.parse(diverseFoodUrl),
      headers: {"Accept": "application/json"},
    );
    print('👉 url:: get ' + diverseFoodUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> diverseFoodPersentListJson = json.decode(response.body);
      return DiverseFoodPersentListModel.fromJson(diverseFoodPersentListJson);
    } else {
      throw Exception("error fetching diverse food persent list. statusCode: ${response.statusCode}");
    }
  }

  Future<DiverseFoodStatsModel> diverseFoodStatsResponse() async {
    String token = await loadToken();
    String currentMonth =
        "${DateTime.now().year}-${DateTime.now().month > 9 ? DateTime.now().month : "0${DateTime.now().month}"}";
    _diverseFoodUrl += "stats?api_token=$token&where[0][0]=month&where[0][1]==&where[0][2]=$currentMonth";
    final response = await http.get(
      Uri.parse(_diverseFoodUrl),
      headers: {"Accept": "application/json"},
    );
    log('diverseFoodStatsResponse:: get ' + _diverseFoodUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> diverseFoodStatJson = json.decode(response.body);
      return DiverseFoodStatsModel.fromJson(diverseFoodStatJson);
    } else {
      throw Exception("error fetching diverse food stat");
    }
  }

  Future<DiverseFoodPresentDiscountModel> diverseFoodPresentDiscountResponse() async {
    String token = await loadToken();
    _diverseFoodUrl += "discounts?api_token=$token&where[0][0]=start_at&" +
        "where[0][1]=<&where[0][2]=now()&where[1][0]=end_at&where[1][1]=>&where[1][2]=now()";
    final response = await http.get(
      Uri.parse(_diverseFoodUrl),
      headers: {"Accept": "application/json"},
    );
    log('diverseFoodPresentDiscountResponse:: get ' + _diverseFoodUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> diverseFoodPresentDiscountJson = json.decode(response.body);
      return DiverseFoodPresentDiscountModel.fromJson(diverseFoodPresentDiscountJson);
    } else {
      throw Exception("error fetching diverse food present discount. StatusCode: ${response.statusCode}");
    }
  }

  Future<DiverseFoodFutureDiscountModel> diverseFoodFutureDiscountResponse() async {
    String token = await loadToken();
    _diverseFoodUrl += "settings/future-level?api_token=$token";
    final response = await http.get(
      Uri.parse(_diverseFoodUrl),
      headers: {"Accept": "application/json"},
    );
    log('diverseFoodFutureDiscountResponse:: get ' + _diverseFoodUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> diverseFoodFutureDiscountJson = json.decode(response.body);
      return DiverseFoodFutureDiscountModel.fromJson(diverseFoodFutureDiscountJson);
    } else {
      throw Exception("error fetching diverse food present discount. StatusCode: ${response.statusCode}");
    }
  }

  Future<DiverseFoodAssortmentListModel> diverseFoodAssortmentListResponse(
      {@required bool isRated, @required int page}) async {
    String token = await loadToken();
    _diverseFoodUrl = "$apiHead/clients/api/profile/purchases-month?api_token=$token&page=$page";
    if (isRated) {
      _diverseFoodUrl += "&where[0][0]=is_rated&where[0][1]==&where[0][2]=1";
    }
    if (!isRated) {
      _diverseFoodUrl += "&where[0][0]=is_rated&where[0][1]==&where[0][2]=0";
    }
    final response = await http.get(
      Uri.parse(_diverseFoodUrl),
      headers: {"Accept": "application/json"},
    );
    log('diverseFoodAssortmentListResponse:: get ' + _diverseFoodUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> diverseFoodAssortmentListJson = json.decode(response.body);
      return DiverseFoodAssortmentListModel.fromJson(diverseFoodAssortmentListJson);
    } else {
      throw Exception("error to fetch Diverse Food Assortment List. StatusCode: ${response.statusCode}");
    }
  }
}

//Любимый продукт
class FavoriteProductProvider {
  String nowTime =
      "${DateTime.now().year}-${DateTime.now().month < 10 ? "0${DateTime.now().month}" : DateTime.now().month}-${DateTime.now().day < 10 ? "0${DateTime.now().day}" : DateTime.now().day} ${DateTime.now().hour < 10 ? "0${DateTime.now().hour}" : DateTime.now().hour}:${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : DateTime.now().minute}:${DateTime.now().second < 10 ? "0${DateTime.now().second}" : DateTime.now().second}";
  String favoriteProductUrl = "$apiHead/clients/api/profile/active-promo-favorite-assortments";

  // get favorite product
  Future<FavoriteProductModel> getFavoriteProductResponse() async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    favoriteProductUrl += "?api_token=$token&per_page=20&store_uuid=$shopUuid";
    favoriteProductUrl += "&where[0][0]=active_to&where[0][1]=>&where[0][2]=$nowTime";
    final response = await http.get(
      Uri.parse(favoriteProductUrl),
      headers: {"Accept": "application/json"},
    );
    print('🤍:: getFavoriteProductResponse get ' + favoriteProductUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> favoriteProductJson = json.decode(response.body);
      return FavoriteProductModel.fromJson(favoriteProductJson);
    } else {
      throw Exception("error fetching favorite Product. StatusCode: ${response.statusCode}");
    }
  }

  //set favorite product

  Future<String> setFavoriteProductResponse({@required String assortmentUuid, @required String variantUuid}) async {
    String token = await loadToken();

    favoriteProductUrl = "$apiHead/clients/api/profile/promo-favorite-assortment-variants/$variantUuid/activate";
    final response = await http.post(Uri.parse(favoriteProductUrl),
        headers: {"Accept": "application/json"}, body: {"api_token": token, "assortment_uuid": assortmentUuid});
    print('🤍:: setFavoriteProductResponse post ' + favoriteProductUrl);
    // print('api_token:: ' + token);
    // print('assortment_uuid:: ' + assortmentUuid);
    if (response.statusCode == 204) {
      return "ok";
    } else if (response.statusCode == 400) {
      if (response.body.contains("Discount is already activated")) {
        return "alreadyActivated";
      }
      return "error";
    } else if (response.statusCode == 401)
      return "old token";
    else {
      throw Exception("error setting fovorite product");
    }
  }

  //get variant uuid
  Future<FavoriteProductVariantUuidModel> getFavoriteProductVariantUuidResponse() async {
    String token = await loadToken();
    favoriteProductUrl = "$apiHead/clients/api/profile/promo-favorite-assortment-variants?api_token=$token";
    favoriteProductUrl += "&where[0][0]=can_be_activated_till&where[0][1]=>&where[0][2]=$nowTime";
    final response = await http.get(
      Uri.parse(favoriteProductUrl),
      headers: {"Accept": "application/json"},
    );
    print('🤍🤍🤍🤍🤍🤍🤍:: getFavoriteProductVariantUuidResponse get ' + favoriteProductUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> favoriteProductVariantUuidJson = json.decode(response.body);
      return FavoriteProductVariantUuidModel.fromJson(favoriteProductVariantUuidJson);
    } else {
      throw Exception("error fetching variant uuid. StatusCode: ${response.statusCode} ");
    }
  }
}

//класс для рекомендаций
class RecomendationProvider {
  String recomendationUrl;

  Future<List<AssortmentsListModel>> getRecomendationListResponse({@required int page}) async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();

    recomendationUrl = shopUuid == null || shopUuid == ""
        ? '$apiHead/clients/api/assortments?&page=$page'
        : '$apiHead/clients/api/stores/$shopUuid/assortments?&page=$page';

    if (token != "guest") {
      recomendationUrl +=
          "&api_token=$token&where[0][0]=properties&where[0][1]==&where[0][2]=%D0%A0%D0%B5%D0%BA%D0%BE%D0%BC%D0%B5%D0%BD%D0%B4%D0%B0%D1%86%D0%B8%D1%8F";
    }
    final response = await http.get(
      Uri.parse(recomendationUrl),
      headers: {"Accept": "application/json"},
    );
    log('get рекомендуемые товары getRecomendationListResponse:: ' + recomendationUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> recomendationListJson = json.decode(response.body);
      return RecomendationListModel.fromJson(recomendationListJson).data;
    } else {
      throw Exception("error fetching Recomendation list");
    }
  }
}

//класс уведомлений
class NotificationsProvider {
  String notificationsUrl = "$apiHead/clients/api/profile/notifications";

  Future<NotificationsListModel> getNotificationListResponse({@required int page}) async {
    String token = await loadToken();
    final response = await http.get(
      Uri.parse(notificationsUrl + "?api_token=$token&page=$page"),
      headers: {"Accept": "application/json"},
    );
    log('url:: get ' + notificationsUrl + "?api_token=$token&page=$page");
    if (response.statusCode == 200) {
      final Map<String, dynamic> notificationListJson = json.decode(response.body);
      return NotificationsListModel.fromJson(notificationListJson);
    } else {
      throw Exception('error fetching notification list!!!');
    }
  }
}

// класс для заказов (order)
class OrderProvider {
  String body;
  String token;
  String orderUrl = "$apiHead/clients/api/profile/orders";

  Future<bool> setRatingForAssortmentInOrderResponse(
      {@required String orderUuid,
      @required String orderProductUuid,
      @required double value,
      @required String comment}) async {
    String token = await loadToken();
    String urlOrderMark = "$orderUrl/products/$orderProductUuid/set-rating";
    final response = await http.post(
      Uri.parse(urlOrderMark),
      body: {"value": value.toInt().toString(), "comment": comment, "api_token": token},
      headers: {"Accept": "application/json"},
    );
    print('🟢:: post setRatingForAssortmentInOrderResponse:::::::: ' + urlOrderMark);
    // print('value:: ' + value.toInt().toString() + ', comment:: ' + comment + ', api_token:: ' + token);
    if (response.statusCode == 204) {
      return true;
    }
    {
      // throw Exception('Error to set assortment in order comments and mark!!!');
      return false;
    }
  }

  // получить список заказов
  Future<OrderListModel> getOrderListResponse(int page) async {
    String token = await loadToken();
    orderUrl += "?api_token=$token&page=$page&order_by[created_at]=desc";

    final response = await http.get(Uri.parse(orderUrl), headers: {
      'Accept': 'application/json',
    });
    print('🟢:: get getOrderListResponse::::::::: ' + orderUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> orderListResponseJson = json.decode(response.body);
      return OrderListModel.fromJson(orderListResponseJson);
    } else {
      throw Exception("Server's error: ${response.statusCode}");
    }
  }

  //get Детали Заказа
  Future<OrderDetailsAndCalculateResponseModel> orderDetailseResponse({
    @required String orderId,
  }) async {
    token = await loadToken();
    orderUrl = "$orderUrl/$orderId?api_token=$token";

    final response = await http.get(Uri.parse(orderUrl), headers: {'Accept': 'application/json'});
    print('url 🛒🟢 orderDetailseResponse get:: ' + orderUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> orderDetailsResponseJson = json.decode(response.body);
      return OrderDetailsAndCalculateResponseModel.fromJson(orderDetailsResponseJson);
    } else {
      throw Exception(response.body.toString());
    }
  }

  // Создать заказ
  Future<OrderCreateResponseModel> createOrderResponse({
    @required String clientCreditCardUuid,
    String clientComment,
    String promocode,
    String clientEmail,
    String address,
    int floor,
    int entrance,
    int apartmentNumber,
    String intercomCode,
    String plannedDeliveryDatetimeFrom,
    String plannedDeliveryDatetimeTo,
    String orderDeliveryTypeId,
    String orderPaymentTypeId,
    int subtractBonusesCount,
    List<ProductModelForOrderRequest> productModelForOrderRequestList,
  }) async {
    token = await loadToken();
    String storeUuid = await loadShopUuid();
    body = json.encode({
      "api_token": token,
      "order": {
        if (promocode != null && promocode != "") "promocode": promocode,
        if (clientCreditCardUuid != null && orderPaymentTypeId != "cash")
          "client_credit_card_uuid": clientCreditCardUuid,
        "planned_delivery_datetime_from": plannedDeliveryDatetimeFrom,
        if (subtractBonusesCount != null) "paid_bonus": subtractBonusesCount,
        "client_comment": clientComment,
        "planned_delivery_datetime_to": plannedDeliveryDatetimeTo,
        "store_user_uuid": storeUuid,
        if (clientEmail != null) "client_email": clientEmail,
        "order_delivery_type_id": orderDeliveryTypeId,
        "order_payment_type_id": orderPaymentTypeId,
        if (orderDeliveryTypeId == "delivery")
          "client_address_data": {
            if (address != null) "address": address,
            if (floor != null) "floor": floor,
            if (entrance != null) "entrance": entrance,
            if (apartmentNumber != null) "apartment_number": apartmentNumber,
            if (intercomCode != null) "intercom_code": intercomCode
          },
        "promocode": "test15"
      },
      "products": List<dynamic>.from(productModelForOrderRequestList.map((x) => x.toJson()))
    });
    final response = await http.post(Uri.parse("$orderUrl"),
        body: body, headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});
    print('url 🛒🟢 createOrderResponse post:: ' + orderUrl + "а body ниже:");
    print('body:: ' + orderDeliveryTypeId + 'есть еще другие параметры см сервисы');
    if (response.statusCode == 201) {
      final Map<String, dynamic> orderCreatedResponseJson = json.decode(response.body);
      return OrderCreateResponseModel.fromJson(orderCreatedResponseJson);
    } else {
      if (response.statusCode == 400) {
        if (jsonDecode(response.body)['message'] != null)
          throw OrderException(errorText: jsonDecode(response.body)['message']);
        else
          throw Exception(response.body);
        //return OrderCreateResponseModel();
      } else {
        throw Exception(response.body);
      }
    }
  }

  //services Расчёт заказа
  Future<OrderDetailsAndCalculateResponseModel> orderCalculateResponse({
    @required String orderDeliveryTypeId,
    @required String orderPaymentTypeId,
    int subtractBonusesCount,
    String promocode,
    @required List<ProductModelForOrderRequest> productModelForOrderRequestList,
  }) async {
    token = await loadToken();
    String storeUuid = await loadShopUuid();
    body = json.encode({
      "api_token": token,
      "order": {
        if (promocode != null && promocode != "") "promocode": promocode,
        "order_payment_type_id": orderPaymentTypeId,
        "store_user_uuid": storeUuid,
        "order_delivery_type_id": orderDeliveryTypeId == null ? "delivery" : orderDeliveryTypeId,
        if (subtractBonusesCount != null && subtractBonusesCount != 0) "paid_bonus": subtractBonusesCount,
      },
      "products": List<dynamic>.from(productModelForOrderRequestList.map((x) => x.toJson()))
    });
    String url = "$orderUrl/calculate";
    final response = await http.post(Uri.parse(url),
        body: (body), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'});
    log('--url 🛒📖orderCalculateResponse post 🟡:: ' + url);
    print('--body 🛒📖:: ' + body);
    print('--response 🛒📖:: ' + response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> orderCalculateResponseJson = json.decode(response.body);
      final dynamic totalPriceForProductsWithDiscount =
          orderCalculateResponseJson['data']['total_price_for_products_with_discount'];
      if (orderCalculateResponseJson['data']["promocode"] != null)
        log('--response 🛒📖🎁 promocode:: ' + orderCalculateResponseJson['data']["promocode"]);
      if (totalPriceForProductsWithDiscount != null) {
        double totalPriceAsDouble;
        if (totalPriceForProductsWithDiscount is int) {
          totalPriceAsDouble = totalPriceForProductsWithDiscount.toDouble();
        } else if (totalPriceForProductsWithDiscount is double) {
          totalPriceAsDouble = totalPriceForProductsWithDiscount;
        } else {
          throw Exception('Ошибка total_price_for_products_with_discount');
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(SharedKeys.totalPriceForProductsWithDiscount, totalPriceAsDouble);
      }

      return OrderDetailsAndCalculateResponseModel.fromJson(orderCalculateResponseJson);
    } else {
      // print(toCurl(response.request));
      throw Exception(response.body.toString());
    }
  }
}

// класс для корзины
class BasketProvider {
  String basketUrl = "$apiHead/clients/api/profile/shopping-cart";
  String token;

  Future<bool> fillBasketFromORderResponse(String orderUuid) async {
    token = await loadToken();
    basketUrl += "/fill-from-order/$orderUuid";
    final response =
        await http.post(Uri.parse(basketUrl), headers: {"Accept": "application/json"}, body: {"api_token": token});
    log('url 🛒  fillBasketFromORderResponse post:: ' + basketUrl);
    // print('api_token:: ' + token);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<BasketListModel> getBasketListResponse() async {
    token = await loadToken();
    String shopUuid = await loadShopUuid();

    basketUrl += "/assortments?api_token=$token";
    if (shopUuid != null) {
      basketUrl += "&store_uuid=$shopUuid";
    }
    final response = await http.get(
      Uri.parse(basketUrl),
      headers: {"Accept": "application/json"},
    );
    log('url 🛒 getBasketListResponse товары в корзине:: ' + basketUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> basketListJson = json.decode(response.body);
      return BasketListModel.fromJson(basketListJson);
    } else if (response.statusCode == 401) {
      return BasketListModel();
    } else {
      throw Exception('Error fetching basket list!!!');
    }
  }

  //Заполнение корзины товарами из списка покупок
  Future<bool> addShoppingListToBasket(String shoppingListUuid) async {
    token = await loadToken();
    basketUrl = "$apiHead/clients/api/profile/shopping-cart/fill-from-shopping-list/{$shoppingListUuid}";
    final response =
        await http.post(Uri.parse(basketUrl), headers: {"Accept": "application/json"}, body: {"api_token": token});
    log('url 🛒 Заполнение корзины товарами из списка покупок post:: ' + basketUrl);
    // print('api_token:: ' + token);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addProductInBasket(String productUuid, double quantity) async {
    token = await loadToken();
    basketUrl += "/assortments";
    final response = await http.post(Uri.parse(basketUrl),
        body: {'uuid': productUuid, if (quantity != null) 'quantity': quantity.toStringAsFixed(2), 'api_token': token},
        headers: {'Accept': 'application/json'});
    log('url 🛒addProductInBasket post:: ' + basketUrl);
    // print('uuid:: ' + productUuid);
    // if (quantity != null) print('quantity:: ' + quantity.toStringAsFixed(2));
    // print('api_token:: ' + token);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> reomoveProductFromBasket(String productUuid) async {
    token = await loadToken();
    final response = await http.delete(Uri.parse(basketUrl + "/assortments/$productUuid?api_token=$token"),
        headers: {'Accept': 'application/json'});
    log('url 🛒reomoveProductFromBasket delete:: ' + basketUrl + "/assortments/$productUuid?api_token=$token");
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProductInBasket({String productUuid, double quantity}) async {
    token = await loadToken();
    final response = await http.post(Uri.parse(basketUrl + "/assortments/update"),
        body: {'uuid': productUuid.toString(), 'quantity': quantity.toStringAsFixed(2), 'api_token': token},
        headers: {'Accept': 'application/json'});
    log('url 🛒updateProductInBasket post:: ' + basketUrl + "/assortments/update");
    print('body: uuid:: ' + productUuid.toString() + ', quantity:: ' + quantity.toStringAsFixed(2));
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeAllBasket() async {
    token = await loadToken();
    final response = await http
        .delete(Uri.parse("$basketUrl/assortments?api_token=$token"), headers: {'Accept': 'application/json'});
    log('url 🛒removeAllBasket delete:: ' + "$basketUrl/assortments?api_token=$token");
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}

//Для оценки и коментария в чеке
class SetRatingForAssortmentProvider {
  String _url = "";

  Future<bool> setRatingForAssortmentResponse(
      {@required String receiptUuid,
      @required String receiptLineUuid,
      @required double value,
      @required String comment}) async {
    String token = await loadToken();
    _url =
        "$apiHead/clients/api/profile/receipts/$receiptUuid/lines/$receiptLineUuid/set-rating?api_token=$token&value=${value.toStringAsFixed(0)}&comment=$comment";
    final response = await http.put(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    log('url:: put Для оценки и коментария в чеке ' + _url);
    if (response.statusCode == 204) {
      return true;
    }
    {
      return false;
    }
  }
}

//get assortment comments
class AssrtmentCommentsProvider {
  Future<AssortmentCommentsModel> getAssortmentCommentsResponse(
      {@required String assortmentUuid, @required int perPage}) async {
    String token = await loadToken();
    String url =
        "$apiHead/clients/api/rating-scores/assortments/clients?where[0][0]=assortment_uuid&where[0][1]=like&where[0][1]=$assortmentUuid&per_page=$perPage";
    if (token != "guest") {
      url += "&api_token=$token";
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );
    log('getAssortmentCommentsResponse:: get ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> assortmentCommentsJson = json.decode(response.body);
      return AssortmentCommentsModel.fromJson(assortmentCommentsJson);
    } else {
      throw Exception('Error fetching assortment comments!!!');
    }
  }
}

class GetCodeByPhoneProvider {
  Future<bool> getAuthResponse({@required String phone}) async {
    final response = await http.post(Uri.parse("$apiHead/clients/api/auth/login-via-phone"),
        body: {"phone": phone}, headers: {"Accept": "application/json"});
    // print(toCurl(response.request));
    log('$phone🔑 getAuthResponse post ' + "$apiHead/clients/api/auth/login-via-phone");
    // print('phone:: ' + phone);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

class GetTokenByPhoneProvider {
  Future<String> getTokenResponse({@required String phone, @required String code}) async {
    final response = await http.post(Uri.parse("$apiHead/clients/api/auth/login-via-phone"),
        body: {'phone': phone, 'code': code}, headers: {'Accept': 'application/json'});
    print('🔑 getTokenResponse post ' + "$apiHead/clients/api/auth/login-via-phone");
    // print('phone:: ' + phone + ', code::' + code);
    if (response.statusCode == 200) {
      final Map<String, dynamic> tokenJson = json.decode(response.body);
      return GetTokenbyPhoneModel.fromJson(tokenJson).getToken;
    } else if (response.statusCode == 400) {
      return '400';
    } else if (response.statusCode == 422) {
      return '422';
    } else {
      return 'error';
    }
  }
}

//stores class
class ShopsListProvider {
  Future<AddressesShopModel> getNearbyStoreModel({@required Point position}) async {
    String token = await loadToken();
    String url = '$apiHead/clients/api/stores/find-nearby';
    if (token != null) {
      url += "?api_token=$token";
    }
    // url += "&latitude=${position.latitude}&longitude=${position.longitude}&limit=1";
    url += "&latitude=${position.latitude}&longitude=${position.longitude}";
    var response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    print('url:: 📍 магазины рядом get Future<FindNearbyStoreModel> getNearbyStoreModel ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("data") && (jsonResponse["data"] as List).isNotEmpty) {
        final nearestShopJson = jsonResponse["data"][0];
        print('📍 Найден ближайший магазин: ${nearestShopJson["uuid"]}');
        return AddressesShopModel.fromJson(nearestShopJson);
      } else {
        print('❌ Нет магазинов рядом!');
        return null; // Если магазинов нет, вернём null
      }
    } else {
      throw Exception('Error fetching near by store model!!!');
    }
  }

  Future<AddressesShopListModel> getShopsList(
      {bool hasParking, bool hasReadyMeals, bool hasAtms, bool isfavorite, bool isOpenNow, String searchText}) async {
    String token = await loadToken();
    String url = '$apiHead/clients/api/stores?per_page=1000&order_by[address]=asc';
    if (token != 'guest') {
      url += '&api_token=$token';
    }
    if (searchText != null) {
      url += "&where[0][0]=address&where[0][1]=ilike&where[0][2]=%$searchText%";
    }
    if (hasParking != null && hasParking != false) {
      url += "&where[1][0]=has_parking&where[1][1]=like&where[1][2]=true";
    }
    if (hasReadyMeals != null && hasReadyMeals != false) {
      url += "&where[2][0]=has_ready_meals&where[2][1]=like&where[2][2]=true";
    }
    if (hasAtms != null && hasAtms != false) {
      url += "&where[3][0]=has_atms&where[3][1]=like&where[3][2]=true";
    }
    if (isfavorite != null && isfavorite != false) {
      url += "&where[4][0]=is_favorite&where[4][1]=like&where[4][2]=true";
    }

    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    log('url:: 🏠 адреса магазинов Future<ShopsModel> getShopsList: ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> shopsListJson = json.decode(response.body);
      return AddressesShopListModel.fromJson(shopsListJson);
    } else {
      throw Exception('Error fetching shops!!!');
    }
  }
}

// get shop details
class ShopDetailsProvider {
  Future<AddressesShopModel> getShopDetails(String uuid) async {
    String token = await loadToken();
    String url = '$apiHead/clients/api/stores/{$uuid}';

    if (token != 'guest') {
      url += '?api_token=$token';
    }
    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    print('url:: get ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> shopDetailJson = json.decode(response.body);
      return AddressesShopModel.fromJson(shopDetailJson);
    } else {
      throw Exception('Error fetching shop details!!!');
    }
  }
}

class CatalogsProvider {
  final String catalogUuid;
  final int currentPage;

  CatalogsProvider({this.currentPage, this.catalogUuid});

  Future<List<CatalogListModel>> getCatalogsForPagination() async {
    Response response;
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    String url =
        "$apiHead/clients/api/catalogs?where[0][0]=assortments_count_in_store&where[0][1]=%3E&where[0][2]=0&page=$currentPage&order_by[sort_number]=asc&order_by[name]=asc&per_page=200";
    if (token != "guest") {
      url += "&api_token=$token";
    }
    if (catalogUuid != null) {
      print(
          'if (catalogUuid != null) if ДОЧЕРНИЕ => url = url + &where[1][0]=catalog_uuid&where[1][1]=like&where[1][2]=$catalogUuid');
      url = url + '&where[1][0]=catalog_uuid&where[1][1]=like&where[1][2]=$catalogUuid';
      if (shopUuid != null) {
        print('if (shopUuid != null) => url = url + "&store_uuid=$shopUuid"');
        url = url + "&store_uuid=$shopUuid";
      }
      response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final Map<String, dynamic> catalogsJson = json.decode(response.body);
        return CatalogsModel.fromJson(catalogsJson).data;
      } else {
        throw Exception('Error catalog List!!!');
      }
    } else {
      if (shopUuid != null) {
        print(
            'if (catalogUuid != null) else РОДИТЕЛЬСКИЕ => url = url + &where[1][0]=level&where[1][1]=like&where[1][2]= 1 а потом 2 &store_uuid=$shopUuid');
        String urlLevel1 = '$url&where[1][0]=level&where[1][1]=like&where[1][2]=1&store_uuid=$shopUuid';
        String urlLevel2 = '$url&where[1][0]=level&where[1][1]=like&where[1][2]=2&store_uuid=$shopUuid';
        print('url:: категории urlLevel1️⃣ get: ' + urlLevel1);
        var responseLevel1 = await http.get(Uri.parse(urlLevel1), headers: {'Accept': 'application/json'});
        print('url:: категории urlLevel2️⃣ get: ' + urlLevel2);
        var responseLevel2 = await http.get(Uri.parse(urlLevel2), headers: {'Accept': 'application/json'});

        if (responseLevel1.statusCode == 200 && responseLevel2.statusCode == 200) {
          var topLevelJson = json.decode(responseLevel1.body)['data'] as List;
          var secondLevelJson = json.decode(responseLevel2.body)['data'] as List;

          List<CatalogListModel> topLevelCatalogs = topLevelJson.map((e) => CatalogListModel.fromJson(e)).toList();
          List<CatalogListModel> secondLevelCatalogs =
              secondLevelJson.map((e) => CatalogListModel.fromJson(e)).toList();

          Map<String, List<CatalogListModel>> secondLevelMap = {};
          for (var secondLevelCatalog in secondLevelCatalogs) {
            secondLevelMap.putIfAbsent(secondLevelCatalog.catalogUuid, () => []).add(secondLevelCatalog);
          }

          for (var topLevelCatalog in topLevelCatalogs) {
            topLevelCatalog.subcatalog = secondLevelMap[topLevelCatalog.uuid] ?? [];
          }

          return topLevelCatalogs;
        } else {
          throw Exception('Error catalog List!!!');
        }
      }
    }
    return [];
  }
}

//получить продукты
class AssortmentsProvider {
  final String catalogUuid;
  final bool isFavorite;
  final String barcodes;
  final List<String> brandName;

  final int currentPage;
  final List<String> activeTagsList;
  final String searchText;
  final bool isRecommendations;
  final uuidForAllProductsInCatalog;
  final bool isPromoAssortment;

  AssortmentsProvider({
    this.uuidForAllProductsInCatalog,
    this.isPromoAssortment,
    this.brandName,
    this.barcodes,
    this.isRecommendations,
    this.isFavorite,
    @required this.currentPage,
    this.activeTagsList,
    this.catalogUuid,
    this.searchText,
  });

  Future<List<AssortmentsListModel>> getAssortmentsForImInShop({@required List<String> assortmentsUuidList}) async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    String _urlForImInShopList = shopUuid == null || shopUuid == ""
        ? '$apiHead/clients/api/assortments?page=$currentPage&per_page=20&order_by[name]=asc'
        : '$apiHead/clients/api/stores/$shopUuid/assortments?page=$currentPage&per_page=20&order_by[name]=asc';
    if (token != "guest") {
      _urlForImInShopList += "&api_token=$token";
    }
    if (assortmentsUuidList != null && assortmentsUuidList.isNotEmpty) {
      _urlForImInShopList += "&where[0][0]=uuid&where[0][1]=in";
      for (var i = 0; i < assortmentsUuidList.length; i++) {
        _urlForImInShopList += "&where[0][2][$i]=${assortmentsUuidList[i]}";
      }
    }
    final response = await http.get(Uri.parse(_urlForImInShopList), headers: {'Accept': 'application/json'});
    print('url:: 🍏 get получить продукты (AssortmentsProvider) getAssortmentsForImInShop ::::::::::::::::::::::::: ' +
        _urlForImInShopList);
    if (response.statusCode == 200) {
      final Map<String, dynamic> assortmentsJson = json.decode(response.body);
      return AssortmentsModel.fromJson(assortmentsJson).data;
    } else {
      throw Exception('Error fetching  assortment list for im in shop!!!');
    }
  }

  Future<List<AssortmentsListModel>> getAssortmentsForPagination(
      {bool isAllSubcatalogsWithoutFavorite = false, String subcatalogUuid}) async {
    print('========== !!!!!!!!!! getAssortmentsForPagination subcatalogUuid:::::::::::::::::::::::');
    print('$subcatalogUuid');
    print('----------------------------------------------------------------------------------------');
    log('========== !!!!!!!!!! getAssortmentsForPagination subcatalogUuid = $subcatalogUuid');
    String token = await loadToken();
    //=>
    String shopUuid = await loadShopUuid();
    String _url = shopUuid == null || shopUuid == ""
        ? '$apiHead/clients/api/assortments?page=$currentPage&per_page=20&order_by[name]=asc'
        : '$apiHead/clients/api/stores/$shopUuid/assortments?page=$currentPage&per_page=20&order_by[name]=asc';
    // if (isAllSubcatalogsWithoutFavorite != null && isAllSubcatalogsWithoutFavorite && (isFavorite == null || isFavorite == false) && (isPromoAssortment == null || isPromoAssortment == false)) {
    if (isAllSubcatalogsWithoutFavorite != null && isAllSubcatalogsWithoutFavorite) {
      // это срабатывает когда нажимаем на подкатегорию, 5 часов мучилась (и их не залогаю) чтобы сделать там норм подгрузку но тогда непонятно почему избранное перестает работать
      // и поэтому я вписала per_page=500, но когда открываем категорию 2го уровня у которой нет подкатегорий 3го уровня, там все идеально подгружается
      // например колбасные изделия
      _url =
          "$apiHead/clients/api/stores/$shopUuid/assortments?page=1&order_by[catalog_name]=asc&per_page=500&api_token=$token&where[1][0]=catalog_uuid&where[1][1]=in&store_uuid=$shopUuid&where[1][2][0]=$subcatalogUuid";
      if (isFavorite != null && isFavorite == true) {
        _url = _url + '&where[2][0]=is_favorite&where[2][1]=like&where[2][2]=true';
      }
      if (isPromoAssortment != null && isPromoAssortment != false) {
        _url += "&where[6][0]=has_yellow_price&where[6][1]==&where[6][2]=true";
      }
    } else {
      if (subcatalogUuid != null) {
        log('subcatalogUuid = $subcatalogUuid');
        _url = _url + '&where[0][0]=catalog_uuid&where[0][1]=like&where[0][2]=$subcatalogUuid';
      }
      if (catalogUuid != null) {
        _url = _url + '&where[0][0]=catalog_uuid&where[0][1]=like&where[0][2]=$catalogUuid';
      }
      if (searchText != null) {
        _url = _url + '&where[1][0]=name&where[1][1]=ilike&where[1][2]=%$searchText%';
      }
      if (isFavorite != null && isFavorite == true) {
        _url = _url + '&where[2][0]=is_favorite&where[2][1]=like&where[2][2]=true';
      }
      if (isRecommendations != null) {
        _url += "&where[3][0]=properties&where[3][1]=in&where[3][2][0]=%D0%A0%D0%B5%D0%BA%D0%BE%D0%BC%D" +
            "0%B5%D0%BD%D0%B4%D0%B0%D1%86%D0%B8%D1%8F&where[3][2][1]=%D0%94%D0%B0";
      }
      if (brandName != null && brandName.isNotEmpty) {
        _url += "&where[4][0]=assortment_brand_uuid&where[4][1]=in";
        for (var i = 0; i < brandName.length; i++) {
          _url += "&where[4][2][$i]=${brandName[i]}";
        }
      }
      if (uuidForAllProductsInCatalog != null) {
        _url += "&where[5][0]=catalog_with_children_uuid&where[5][1]==&where[5][2]=$uuidForAllProductsInCatalog";
      }
      //=>
      if (isPromoAssortment != null && isPromoAssortment != false) {
        _url += "&where[6][0]=has_yellow_price&where[6][1]==&where[6][2]=true";
      }

      if (activeTagsList != null && activeTagsList.isNotEmpty) {
        for (int i = 0; i < activeTagsList.length; i++) {
          _url = _url + '&where[${i + 7}][0]=tags&where[${i + 7}][1]=like&where[${i + 7}][2]=${activeTagsList[i]}';
        }
      }
      if (token != "guest") {
        _url = _url + "&api_token=$token";
      }
      // if (shopUuid != null) {
      //   url = url + "&store_uuid=$shopUuid";
      // }
    }
    final response = await http.get(Uri.parse(_url), headers: {'Accept': 'application/json'});
    print(
        '-url:: get получить продукты 🍎 (AssortmentsProvider) getAssortmentsForPagination ::::::::::::::::::::::::: ' +
            _url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> assortmentsJson = json.decode(response.body);
      return AssortmentsModel.fromJson(assortmentsJson).data;
    } else {
      throw Exception('Error fetching  assortment list!!!');
    }
  }

  Future<AssortmentsModel> getAssortments() async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    String url = shopUuid == null || shopUuid == ""
        ? '$apiHead/clients/api/assortments?page=$currentPage'
        : '$apiHead/clients/api/stores/{$shopUuid}/assortments?page=$currentPage';
    if (catalogUuid != null) {
      url = url + '&where[0][0]=catalog_uuid&where[0][1]=like&where[0][2]=$catalogUuid';
    }
    if (searchText != null) {
      url = url + '&where[1][0]=name&where[1][1]=ilike&where[1][2]=%$searchText%';
    }

    if (isFavorite != null) {
      url = url + '&where[2][0]=is_favorite&where[2][1]=like&where[2][2]=true';
    }

    if (brandName != null) {
      url += "&where[3][0]=assortment_brand_name&where[3][1]=ilike&where[3][2]=%$brandName%";
    }
    if (activeTagsList != null && activeTagsList.isNotEmpty) {
      for (int i = 0; i < activeTagsList.length; i++) {
        url = url + '&where[${i + 4}][0]=tags&where[${i + 4}][1]=like&where[${i + 4}][2]=${activeTagsList[i]}';
      }
    }
    if (barcodes != null) {
      url += "&where[0][0]=barcodes&where[0][1]==&where[0][2]=$barcodes";
    }

    if (isRecommendations != null) {
      url += "&where[0][0]=properties&where[0][1]=in&where[0][2][0]=%D0%A0%D0%B5%D0%BA%D0%BE%D0%BC%D" +
          "0%B5%D0%BD%D0%B4%D0%B0%D1%86%D0%B8%D1%8F&where[0][2][1]=%D0%94%D0%B0";
    }
    if (token != "guest") {
      url = url + "&api_token=$token";
    }
    if (shopUuid != null) {
      url = url + "&store_uuid=$shopUuid";
    }

    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    print('url:: get 🍎 получить продукты (AssortmentsProvider) getAssortments ::::::::::::::::::::::::: ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> assortmentsJson = json.decode(response.body);
      return AssortmentsModel.fromJson(assortmentsJson);
    } else {
      throw Exception('Error fetching !!!');
    }
  }
}

class TagsProvider {
  Future<TagsModel> getTags() async {
    String token = await loadToken();
    String tagsUrl = '$apiHead/clients/api/tags';
    if (token != "guest") {
      tagsUrl +=
          "?api_token=$token&page=1&per_page=1000&order_by[name]=asc&where[0][0]=fixed_in_filters&where[0][1]=in&where[0][2]=true";
    }
    final response = await http.get(Uri.parse(tagsUrl), headers: {'Accept': 'application/json'});
    print('url:: get ' + tagsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> tagsJson = json.decode(response.body);
      return TagsModel.fromJson(tagsJson);
    } else {
      throw Exception('Error fetching tags!!!');
    }
  }
}

//add store to favorite
class AddShopToFavoriteProvider {
  final String storeUuid;

  AddShopToFavoriteProvider({@required this.storeUuid});

  Future<bool> getisAddShopTofavoriteresponse() async {
    String token = await loadToken();
    final response = await http.post(
      Uri.parse('$apiHead/clients/api/profile/favorite-stores'),
      body: {'store_uuid': storeUuid, 'api_token': token},
      headers: {'Accept': 'application/json'},
    );
    print('url:: post ' + '$apiHead/clients/api/profile/favorite-stores');
    // print('store_uuid:: ' + storeUuid + ', ' + 'api_token: ' + token);
    if (response.statusCode == 204)
      return true;
    else {
      return false;
    }
  }
}

//delete store to favorite
class DeleteShopToFavoriteProvider {
  final String storeUuid;

  DeleteShopToFavoriteProvider({@required this.storeUuid});

  Future<bool> getisDeleteShopTofavoriteresponse() async {
    String token = await loadToken();
    final response = await http.delete(
      Uri.parse('$apiHead/clients/api/profile/favorite-stores/$storeUuid?api_token=$token'),
      headers: {'Accept': 'application/json'},
    );
    print('url:: delete ' + '$apiHead/clients/api/profile/favorite-stores/$storeUuid?api_token=$token');
    if (response.statusCode == 204)
      return true;
    else {
      return false;
    }
  }
}

class ProductDetailsProvider {
  final String uuid;

  ProductDetailsProvider({@required this.uuid});

  Future<ProductDetailsModel> getProductDetailsResponse() async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    String url = '$apiHead/clients/api/assortments/$uuid';
    if (token != "guest") {
      url = url + "?api_token=$token";
      if (shopUuid != null) {
        url += "&store_uuid=$shopUuid";
      }
    } else {
      if (shopUuid != null) {
        url += "?store_uuid=$shopUuid";
      }
    }

    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});
    print('url:: get ' + url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> productDetJson = json.decode(response.body);
      return ProductDetailsModel.fromJson(productDetJson);
    } else {
      throw Exception('Error fetching product details');
    }
  }
}

//add and delete product from favorite
class AddDeleteProductToFavoriteProvider {
  final String productUuid;
  final bool isLiked;

  AddDeleteProductToFavoriteProvider({@required this.isLiked, @required this.productUuid});

  Future<String> getisAddProductTofavoriteResponse() async {
    String token = await loadToken();
    final response = isLiked == false
        ? await http.post(
            Uri.parse('$apiHead/clients/api/profile/favorite-assortments?api_token=$token'),
            body: {'assortment_uuid': productUuid},
            headers: {'Accept': 'application/json'},
          )
        : await http.delete(
            Uri.parse('$apiHead/clients/api/profile/favorite-assortments/{$productUuid}?api_token=$token'),
            headers: {'Accept': 'application/json'},
          );
    print('❤️ getisAddProductTofavoriteResponse');
    isLiked == false
        ? print('isLiked == false url:: post ' +
            '$apiHead/clients/api/profile/favorite-assortments?api_token=$token и body: assortment_uuid: productUuid')
        : print('isLiked == true url:: delete ' +
            '$apiHead/clients/api/profile/favorite-assortments/{$productUuid}?api_token=$token');
    if (response.statusCode == 204)
      return "true";
    else if (response.statusCode == 401)
      return "old token";
    else
      return "false";
  }
}

//Get Profile data
class ProfileProvider {
  String _profileUrl;

  Future<DeleteProfileModel> deleteProfileResponse() async {
    String _token = await loadToken();
    _profileUrl = "$apiHead/clients/api/profile";

    final respone = await http.delete(Uri.parse(_profileUrl),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'});
    print('url:: delete ' + _profileUrl);
    if (respone.statusCode == 200) {
      final Map<String, dynamic> deleteProfileREsponseJson = json.decode(respone.body);
      return DeleteProfileModel.fromJson(deleteProfileREsponseJson);
    } else {
      throw Exception("Error fetching delete profile response");
    }
  }

  Future<bool> loginResponse() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String pushToken;
    try {
      pushToken = await firebaseMessaging.getToken();
    } catch (e) {
      return false;
    }
    String token = await loadToken();
    _profileUrl = "$apiHead/clients/api/profile/push-tokens?api_token=$token";
    final response =
        await http.post(Uri.parse(_profileUrl), headers: {'Accept': 'application/json'}, body: {"token": pushToken});
    print('url:: post ' + _profileUrl);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logoutResponse() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String pushToken;
    try {
      pushToken = await firebaseMessaging.getToken();
    } catch (e) {
      return false;
    }
    String token = await loadToken();
    _profileUrl = "$apiHead/clients/api/profile/push-tokens/$pushToken?api_token=$token";
    final response = await http.delete(Uri.parse(_profileUrl), headers: {'Accept': 'application/json'});
    print('url:: delete ' + _profileUrl);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getPurchasesSumResponse({@required int days}) async {
    String token = await loadToken();
    String purchasesSumUrl = "$apiHead/clients/api/profile/purchases-sum?api_token=$token&days=$days";
    final response = await http.get(Uri.parse(purchasesSumUrl), headers: {'Accept': 'application/json'});
    print('url:: get ' + purchasesSumUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> purchasesSumJson = json.decode(response.body);
      return PurchasesSumModel.fromJson(purchasesSumJson).data.toString();
    } else {
      throw Exception("Error fetching purchases sum. StatusCode: ${response.statusCode}");
    }
  }

  Future<ProfileModel> getProfileResponse() async {
    String token = await loadToken();
    final response = await http
        .get(Uri.parse('$apiHead/clients/api/profile?api_token=$token'), headers: {'Accept': 'application/json'});
    print('url:: get получаем профиль 😎 ' + '$apiHead/clients/api/profile?api_token=$token');
    if (response.statusCode == 200) {
      final Map<String, dynamic> profileJson = json.decode(response.body);
      ProfileModel profileModel = ProfileModel.fromJson(profileJson);
      if (profileModel.data.selectedStoreUserUuid != null) {
        log('🌎🌎🌎🌎🌎🌎 получаем профиль selected_store_user_uuid = ${profileModel.data.selectedStoreUserUuid}');
        log('🌎🌎🌎🌎🌎🌎 получаем профиль selectedStoreAddress = ${profileModel.data.selectedStoreAddress}');
        await prefs.setString(SharedKeys.shopLogo, profileModel.data.image.thumbnails.the200X200);
        await prefs.setString(SharedKeys.shopUuid, profileModel.data.selectedStoreUserUuid);
        await prefs.setString(SharedKeys.shopAddress, profileModel.data.selectedStoreAddress);
      } else {
        log('🌎🌎🌎🌎🌎🌎 в профиле нет выбранного магазина ❗️❗️❗️');
      }

      return profileModel;
    } else {
      if (response.statusCode == 401) {
        return ProfileModel();
      } else {
        throw Exception('Error fetching profile data. StatusCode: ${response.statusCode}');
      }
    }
  }
}

//change profile data
class ProfileUpdateDataProvider {
  final String uuid;
  final String phone;
  final String birthdayDate;
  final String name;
  final int consentToServiceNewsletter;
  final int consentToReceivePromotionalMailings;
  final String email;
  final String sex;
  final String selectedStoreUserUuid;
  final int isAgreeWithDiverseFoodPromo;
  final String appVersion;

  ProfileUpdateDataProvider(
      {this.isAgreeWithDiverseFoodPromo,
      this.birthdayDate,
      this.appVersion,
      this.selectedStoreUserUuid,
      this.name,
      this.uuid,
      @required this.phone,
      this.consentToServiceNewsletter,
      this.consentToReceivePromotionalMailings,
      this.email,
      this.sex});

  Future<bool> getProfileChangeRsponse() async {
    log('📡 Отправляем PUT для обновления профиля с selected_store_user_uuid: $selectedStoreUserUuid');
    String token = await loadToken();
    String phoneFromShared = await loadPhone();

    final response = await http.put(Uri.parse("$apiHead/clients/api/profile?api_token=$token"), headers: {
      'Accept': 'application/json'
    }, body: {
      if (selectedStoreUserUuid != null) "selected_store_user_uuid": selectedStoreUserUuid,
      'phone': phone != null ? phone : phoneFromShared,
      if (name != null) 'name': name,
      if (appVersion != null) "app_version": appVersion,
      if (consentToServiceNewsletter != null) "consent_to_service_newsletter": consentToServiceNewsletter.toString(),
      if (consentToReceivePromotionalMailings != null)
        'consent_to_receive_promotional_mailings': consentToReceivePromotionalMailings.toString(),
      if (email != null) 'email': email,
      if (sex != null) 'sex': sex,
      if (birthdayDate != null) "birth_date": birthdayDate,
      if (isAgreeWithDiverseFoodPromo != null)
        "is_agree_with_diverse_food_promo": isAgreeWithDiverseFoodPromo.toString(),
    });
    log('☎️😊 url:: обновляем профиль put getProfileChangeRsponse ' + "$apiHead/clients/api/profile?api_token=$token");
    log('🌎🌎🌎🌎🌎🌎 обновляем профиль selected_store_user_uuid = $selectedStoreUserUuid');
    if (selectedStoreUserUuid != null) print("*selected_store_user_uuid: $selectedStoreUserUuid");
    print("*phone: ${phone != null ? phone : phoneFromShared}");
    if (name != null) print("*name: $name");
    if (appVersion != null) print("*app_version: $appVersion");
    if (consentToServiceNewsletter != null) print("*consent_to_service_newsletter: $consentToServiceNewsletter");
    if (consentToReceivePromotionalMailings != null)
      print("*consent_to_receive_promotional_mailings: $consentToReceivePromotionalMailings");
    if (email != null) print("*email: $email");
    if (sex != null) print("*sex: $sex");
    if (birthdayDate != null) print("*birth_date: $birthdayDate");
    if (isAgreeWithDiverseFoodPromo != null) print("*is_agree_with_diverse_food_promo: $isAgreeWithDiverseFoodPromo");

    if (response.statusCode == 200) {
      log('✅ Профиль успешно обновлен!');
      return true;
    } else {
      log('❌ Ошибка при обновлении профиля!');
      return false;
    }
  }
}

//get Shopping lists!
class ShoppingListsProvider {
  Future<ShoppingListsModel> getShoppingListsResponse() async {
    String token = await loadToken();
    final response = await http.get(Uri.parse('$apiHead/clients/api/profile/shopping-lists?api_token=$token'),
        headers: {'Accept': 'application/json'});
    print('url:: Получение списков покупок get ' + '$apiHead/clients/api/profile/shopping-lists?api_token=$token');
    if (response.statusCode == 200) {
      final Map<String, dynamic> shoppingListsJson = json.decode(response.body);
      return ShoppingListsModel.fromJson(shoppingListsJson);
    } else {
      throw Exception('Error fetching shopping lists data!. StatusCode: ${response.statusCode}');
    }
  }
}

//get shopping list details
class ShoppingListDetailsProvider {
  Future<ShoppingListDeatailsModel> getShoppingListDetailsResponse({@required String shoppingListUuid}) async {
    String token = await loadToken();
    String shopUuid = await loadShopUuid();
    String shoppingListDetailsUrl = "$apiHead/clients/api/profile/shopping-lists/$shoppingListUuid?api_token=$token";

    if (shopUuid != null) {
      shoppingListDetailsUrl += "&store_uuid=$shopUuid";
    }
    final response = await http.get(Uri.parse(shoppingListDetailsUrl), headers: {'Accept': 'application/json'});
    print('url:: get ' + shoppingListDetailsUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> shoppingListDetailsJson = json.decode(response.body);
      return ShoppingListDeatailsModel.fromJson(shoppingListDetailsJson);
    } else {
      throw Exception('Error fetching shopping lists data!. StatusCode: ${response.statusCode}');
    }
  }
}

//create new shopping list
class CreateNewShoppingListProvider {
  Future<bool> getCreateShoppingListResponse({@required String shoppingListName}) async {
    String token = await loadToken();
    final response = await http.post(Uri.parse('$apiHead/clients/api/profile/shopping-lists'),
        headers: {"Accept": "application/json"}, body: {'name': shoppingListName, 'api_token': token});
    print('url:: post ' + '$apiHead/clients/api/profile/shopping-lists');
    // print('name:: ' + shoppingListName);
    // print('api_token:: ' + token);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateShoppingListResponse(
      {@required String shoppingListName,
      List<double> assortmentsQuantity,
      List<double> assortmentsUuid,
      @required String shoppingListsUuid}) async {
    String token = await loadToken();
    String _url = '$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}';

    final response = await http.put(Uri.parse(_url),
        headers: {"Accept": "application/json"}, body: {'name': shoppingListName, 'api_token': token});
    print('url:: put ' + _url);
    // print('name:: ' + shoppingListName);
    // print('api_token:: ' + token);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

// delete Shopping list
class DeleteShoppingListProvider {
  Future<bool> getDeleteShoppingListResponse({@required String shoppingListsUuid}) async {
    String token = await loadToken();
    final response = await http.delete(
      Uri.parse("$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}?api_token=$token"),
      headers: {"Accept": "application/json"},
    );
    print('url:: delete ' + "$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}?api_token=$token");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

//add product to shopping list
class AddProductToShopingListProvider {
  Future<bool> getAddProducttoShoppingListRespone(
      {@required String shoppingListsUuid, @required String assortmentUuid, @required int quantity}) async {
    String token = await loadToken();
    final response = await http.post(
      Uri.parse("$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}/assortments"),
      body: {"api_token": token, "assortment_uuid": assortmentUuid, "quantity": quantity.toString()},
      headers: {"Accept": "application/json"},
    );
    print('url:: post ' + "$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}/assortments");
    // print('api_token:: ' + token);
    // print('assortment_uuid:: ' + assortmentUuid);
    // print('quantity:: ' + quantity.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}

//Delete product to shopping list
class DeleteProductToShopingListProvider {
  Future<bool> getDeleteProducttoShoppingListRespone(
      {@required String shoppingListsUuid, @required String assortmentUuid}) async {
    String token = await loadToken();
    final response = await http.delete(
      Uri.parse(
          "$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}/assortments/{$assortmentUuid}?api_token=$token"),
      headers: {"Accept": "application/json"},
    );
    print('url:: delete ' +
        "$apiHead/clients/api/profile/shopping-lists/{$shoppingListsUuid}/assortments/{$assortmentUuid}?api_token=$token");
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('error to delete product from shopping list');
    }
  }
}

//get shopping check list
class ShoppingCheckListProvider {
  Future<ShoppingCheckListModel> getShoppingCheckListResponse() async {
    String token = await loadToken();
    final response = await http.get(
      Uri.parse(
          '$apiHead/clients/api/profile/receipts?api_token=$token&where[0][0]=refund_by_receipt_uuid&where[0][1]=is null&order_by[created_at]=desc'),
      headers: {"Accept": "application/json"},
    );
    print('url:: get ' +
        '$apiHead/clients/api/profile/receipts?api_token=$token&where[0][0]=refund_by_receipt_uuid&where[0][1]=is null&order_by[created_at]=desc');
    if (response.statusCode == 200) {
      final Map<String, dynamic> shoppingCheckListJson = json.decode(response.body);
      return ShoppingCheckListModel.fromJson(shoppingCheckListJson);
    } else {
      throw Exception('error fetching shopping checks list');
    }
  }

  Future<List<ShoppingCheckListDataModel>> getShoppingCheckListForPaginationResponse(
      {@required int currentPage}) async {
    String token = await loadToken();
    final response = await http.get(
      Uri.parse(
          '$apiHead/clients/api/profile/receipts?api_token=$token&page=$currentPage&where[0][0]=refund_by_receipt_uuid&where[0][1]=is null&order_by[created_at]=desc'),
      headers: {"Accept": "application/json"},
    );
    print('url:: get ' +
        '$apiHead/clients/api/profile/receipts?api_token=$token&page=$currentPage&where[0][0]=refund_by_receipt_uuid&where[0][1]=is null&order_by[created_at]=desc');
    if (response.statusCode == 200) {
      final Map<String, dynamic> shoppingCheckListJson = json.decode(response.body);
      return ShoppingCheckListModel.fromJson(shoppingCheckListJson).data;
    } else {
      throw Exception('error fetching shopping checks list');
    }
  }
}

// get loyalty cards
class LoyaltyCardsListProvider {
  Future<LoyaltyCardsListModel> getLoyaltyCardsListResponse() async {
    String token = await loadToken();
    final response = await http.get(
      Uri.parse('$apiHead/clients/api/profile/loyalty-cards?api_token=$token'),
      headers: {"Accept": "application/json"},
    );
    print('url:: get ' + '$apiHead/clients/api/profile/loyalty-cards?api_token=$token');
    if (response.statusCode == 200) {
      final Map<String, dynamic> loyaltyCardsListJson = json.decode(response.body);
      return LoyaltyCardsListModel.fromJson(loyaltyCardsListJson);
    } else {
      throw Exception('error fetching lyalty card data');
    }
  }
}

class Asd<St> {}

//get check details
class CheckDetailsProvider {
  String _url = "";

  Future<CheckDetailsModel> getCheckDetailsResponse({@required String receiptUuid}) async {
    String token = await loadToken();
    _url = '$apiHead/clients/api/profile/receipts/{$receiptUuid}?api_token=$token';
    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    print('url:: get ' + _url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> checkDetailsJson = json.decode(response.body);
      return CheckDetailsModel.fromJson(checkDetailsJson);
    } else {
      throw Exception('error fetching check details data');
    }
  }
}

//get check products details
class CheckDetailsProductsProvider {
  String _url = "";

  Future<CheckDetailsProductsModel> getCheckDetailsProductsResponse({@required String receiptUuid}) async {
    String token = await loadToken();

    _url = '$apiHead/clients/api/profile/receipts/{$receiptUuid}/lines?api_token=$token';

    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    print('url:: get ' + _url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> checkDetailsProductsJson = json.decode(response.body);
      return CheckDetailsProductsModel.fromJson(checkDetailsProductsJson);
    } else {
      throw Exception('error fetching check details data');
    }
  }
}

// Рецепты
class ReceiptsListProvider {
  String body;

  Future<ReceiptsListModel> getReceiptsList(String currentPage) async {
    String token = await loadToken();
    String storeUuid = await loadShopUuid();
    String _url =
        "$apiHead/clients/api/meal-receipts?api_token=$token&page=$currentPage&per_page=10&order_by%5Bsection%5D=asc&store_uuid=$storeUuid";
    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    print('url get getReceiptsList 🍓 рецепты:: ' + _url);
    if (response.statusCode == 200) {
      final receiptsListJson = jsonDecode(response.body);
      return ReceiptsListModel.fromMap(receiptsListJson);
    } else {
      throw Exception('error loading receipts list');
    }
  }

  // Future<ReceiptsListModel> getFavoriteReceiptsList(String currentPage) async {
  //   String token = await loadToken();
  //   String _url = "$apiHead/clients/api/meal-receipts?where[0][0]=is_favorite&where[0][1]=%3D&where[0][2]=false&api_token=$token";
  //   final response = await http.get(
  //     Uri.parse(_url),
  //     headers: {"Accept": "application/json"},
  //   );
  //   print('url get getReceiptsList 🍓 только избранные рецепты:: ' + _url);
  //   if (response.statusCode == 200) {
  //     final receiptsListJson = jsonDecode(response.body);
  //     return ReceiptsListModel.fromMap(receiptsListJson);
  //   } else {
  //     throw Exception('error loading getFavoriteReceiptsList');
  //   }
  // }

  Future<UniqueReceipts> getReceiptsUniqueSections() async {
    String token = await loadToken();
    String _url = "$apiHead/clients/api/meal-receipts-unique-sections?api_token=$token";
    final response = await http.get(
      Uri.parse(_url),
      headers: {"Accept": "application/json"},
    );
    print('url get getReceiptsUniqueSections 🍓 рецепты only категории:: ' + _url);
    if (response.statusCode == 200) {
      final receiptsListJson = jsonDecode(response.body);
      return UniqueReceipts.fromMap(receiptsListJson);
    } else {
      throw Exception('error loading receipts sections list');
    }
  }

  Future<SingleRecipeDataModel> getSingleReceipt(String uuid) async {
    String token = await loadToken();
    String _url = "$apiHead/clients/api/meal-receipts/$uuid/?api_token=$token";
    final response = await http.get(Uri.parse(_url), headers: {"Accept": "application/json"});
    print('url:: get getSingleReceipt 🍓 рецепт 1:: ' + _url);
    if (response.statusCode == 200) {
      final receiptsListJson = jsonDecode(response.body);
      return SingleRecipeDataModel.fromMap(receiptsListJson);
    } else {
      throw Exception('error loading receipts list');
    }
  }

  Future<bool> toggleLikeStory(String uuid, bool isFavorite) async {
    //это вообще лайк для сториса рецепта а не избранное
    String token = await loadToken();
    String _url = "$apiHead/clients/api/meal-receipts/$uuid/reaction?api_token=$token";
    final response = await http.post(Uri.parse(_url),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({"is_positive": isFavorite}));
    print('url:: post addToFavorites 🍓 лайк сториса рецепта:: ' + _url);
    // print('is_positive:: ' + isFavorite.toString());
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('error loading receipts list');
    }
  }
}

// Добавить/удалить рецепт в/из избранных - вынесла отдельное по аналогии с доб-ем избранного у товара
class AddOrDeleteReceiptsToFavoriteProvider {
  final String mealReceiptUuid;
  final bool isFavorite;

  AddOrDeleteReceiptsToFavoriteProvider({@required this.isFavorite, @required this.mealReceiptUuid});

  Future<String> addOrDeleteReceiptsToFavoriteResponse() async {
    String token = await loadToken();
    final response = isFavorite == true
        ? await http.delete(
            Uri.parse('$apiHead/clients/api/profile/favorite-meal-receipts/$mealReceiptUuid?api_token=$token'),
            headers: {'Accept': 'application/json'},
          )
        : await http.post(
            Uri.parse('$apiHead/clients/api/profile/favorite-meal-receipts?api_token=$token'),
            body: {'meal_receipt_uuid': mealReceiptUuid},
            headers: {'Accept': 'application/json'},
          );
    isFavorite == false
        ? print('addOrDeleteReceiptsToFavoriteResponse ❤️🍓 url:: delete ' +
            '$apiHead/clients/api/profile/favorite-meal-receipts/$mealReceiptUuid?api_token=$token')
        : print('addOrDeleteReceiptsToFavoriteResponse 🤍🍓 url:: post ' +
            '$apiHead/clients/api/profile/favorite-meal-receipts?api_token=$token и body: assortment_uuid: productUuid');

    if (response.statusCode == 204)
      return "true";
    else if (response.statusCode == 401)
      return "old token";
    else
      return "false";
  }
}

Future<String> loadToken() async {
  SharedPreferences _shared = await SharedPreferences.getInstance();
  log('loadToken::: 🐝 ${_shared.getString(SharedKeys.token)}');
  return _shared.getString(SharedKeys.token);
}

Future<String> loadShopUuid() async {
  SharedPreferences _shared = await SharedPreferences.getInstance();
  log('loadShopUuid::: 🐝 ${_shared.getString(SharedKeys.shopUuid)}');
  return _shared.getString(SharedKeys.shopUuid);
}

Future<String> loadShopName() async {
  SharedPreferences _shared = await SharedPreferences.getInstance();
  log('loadShopName::: 🐝 ${_shared.getString(SharedKeys.shopAddress)}');
  return _shared.getString(SharedKeys.shopAddress);
}

Future<String> loadPhone() async {
  SharedPreferences _shared = await SharedPreferences.getInstance();
  log('loadPhone::: 🐝 ${_shared.getString(SharedKeys.phone)}');
  return _shared.getString(SharedKeys.phone);
}

String getErrorFromCode(int code) {
  switch (code) {
    case 2007:
      return "Указанный адрес находится слишком далеко! Пожалуйста, выберите другой адрес доставки";
    case 2010:
      return "Не смогли произвести списание средств за заказ. Обратитесь за поддержкой в банк или выберите другую карту.";
    default:
      return "Не смогли произвести списание средств за зазказ. Повторите попытку или обратитесь за поддержкой в банк.";
  }
}
