import 'package:smart/models/Assortments_image_model.dart';
import 'package:smart/models/order_list_model.dart';

class OrderDetailsAndCalculateResponseModel {
  OrderDetailsAndCalculateResponseModel({this.data});

  OrderCalculateDataResponseModel data;

  factory OrderDetailsAndCalculateResponseModel.fromJson(Map<String, dynamic> json) => OrderDetailsAndCalculateResponseModel(
        data: OrderCalculateDataResponseModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class OrderCalculateDataResponseModel {
  OrderCalculateDataResponseModel({
    this.uuid,
    this.storeUserUuid,
    this.storeUserFullName,
    this.storeUserAddress,
    this.orderStatusId,
    this.orderDeliveryTypeId,
    this.orderPaymentTypeId,
    this.clientComment,
    this.clientEmail,
    this.clientAddressData,
    this.isPaid,
    this.deliveryPrice, // Доставка
    this.toMinPrice,
    this.minPrice,
    this.totalDiscountForProducts, // скидка по акциям
    this.totalPriceForProductsWithDiscount, // Товаров 1 (1.50 кг)
    this.totalPrice,
    this.totalWeight,
    this.totalQuantity,
    this.plannedDeliveryDatetimeFrom,
    this.plannedDeliveryDatetimeTo,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.number,
    this.totalBonus,
    this.paidBonus,
    this.bonusToCharge,
    this.maxBonusToPaid,
    this.workHoursFrom,
    this.workHoursTill,
    this.toFreeDelivery,
    this.promocode,
  });

  dynamic uuid;
  int number;
  String workHoursFrom;
  String workHoursTill;
  String storeUserUuid;
  String storeUserFullName;
  String storeUserAddress;
  String orderStatusId;
  String orderDeliveryTypeId;
  String orderPaymentTypeId;
  dynamic clientComment;
  dynamic clientEmail;
  OrderListClientAddressData clientAddressData;
  bool isPaid;
  double deliveryPrice;
  double toMinPrice;
  double minPrice;
  double totalDiscountForProducts;
  double totalPriceForProductsWithDiscount;
  double totalPrice;
  double totalWeight;
  double toFreeDelivery;
  var totalQuantity;
  dynamic plannedDeliveryDatetimeFrom;
  dynamic plannedDeliveryDatetimeTo;
  dynamic createdAt;
  dynamic updatedAt;
  List<OrderCalculateProductModel> products;
  int totalBonus;
  int paidBonus;
  int bonusToCharge;
  int maxBonusToPaid;
  String promocode;

  factory OrderCalculateDataResponseModel.fromJson(Map<String, dynamic> json) => OrderCalculateDataResponseModel(
        uuid: json["uuid"],
        workHoursFrom: json["work_hours_from"],
        workHoursTill: json["work_hours_till"],
        totalBonus: json["total_bonus"],
        maxBonusToPaid: json["max_bonus_to_paid"],
        bonusToCharge: json["bonus_to_charge"],
        paidBonus: json["paid_bonus"],
        number: json["number"],
        storeUserUuid: json["store_user_uuid"],
        storeUserFullName: json["store_user_full_name"],
        storeUserAddress: json["store_user_address"],
        orderStatusId: json["order_status_id"],
        orderDeliveryTypeId: json["order_delivery_type_id"],
        orderPaymentTypeId: json["order_payment_type_id"],
        clientComment: json["client_comment"],
        clientEmail: json["client_email"],
        toFreeDelivery: double.tryParse(json["to_free_delivery"].toString()),
        clientAddressData: json["client_address_data"] == null ? null : OrderListClientAddressData.fromJson(json["client_address_data"]),
        isPaid: json["is_paid"],
        deliveryPrice: json["delivery_price"].toDouble(),
        toMinPrice: json["to_min_price"] == null ? null : json["to_min_price"].toDouble(),
        minPrice: json["min_price"] == null ? null : json["min_price"].toDouble(),
        totalDiscountForProducts: json["total_discount_for_products"] == null ? null : json["total_discount_for_products"].toDouble(),
        totalPriceForProductsWithDiscount:
            json["total_price_for_products_with_discount"] == null ? null : json["total_price_for_products_with_discount"].toDouble(),
        totalPrice: json["total_price"] == null ? null : json["total_price"].toDouble(),
        totalWeight: json["total_weight"] == null ? null : json["total_weight"].toDouble(),
        promocode: json["promocode"] == null ? null : json["promocode"],
        totalQuantity: json["total_quantity"],
        plannedDeliveryDatetimeFrom: json["planned_delivery_datetime_from"],
        plannedDeliveryDatetimeTo: json["planned_delivery_datetime_to"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        products: List<OrderCalculateProductModel>.from(json["products"].map((x) => OrderCalculateProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "work_hours_from": workHoursFrom,
        "work_hours_till": workHoursTill,
        "total_bonus": totalBonus,
        "max_bonus_to_paid": maxBonusToPaid,
        "bonus_to_charge": bonusToCharge,
        "paid_bonus": paidBonus,
        "store_user_uuid": storeUserUuid,
        "store_user_full_name": storeUserFullName,
        "store_user_address": storeUserAddress,
        "order_status_id": orderStatusId,
        "order_delivery_type_id": orderDeliveryTypeId,
        "order_payment_type_id": orderPaymentTypeId,
        "client_comment": clientComment,
        "client_email": clientEmail,
        "client_address_data": clientAddressData == null ? null : clientAddressData.toJson(),
        "is_paid": isPaid,
        "delivery_price": deliveryPrice,
        "total_discount_for_products": totalDiscountForProducts,
        "total_price_for_products_with_discount": totalPriceForProductsWithDiscount,
        "total_price": totalPrice,
        "total_weight": totalWeight,
        "total_quantity": totalQuantity,
        "planned_delivery_datetime_from": plannedDeliveryDatetimeFrom,
        "planned_delivery_datetime_to": plannedDeliveryDatetimeTo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "promocode": promocode,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class OrderCalculateProductModel {
  OrderCalculateProductModel({
    this.uuid,
    this.orderUuid,
    this.productUuid,
    this.assortment,
    this.quantity,
    this.totalWeight,
    this.discount,
    this.totalDiscount,
    this.discountableType,
    this.createdAt,
    this.rating,
    this.ratingComment,
    this.updatedAt,
    this.discountTypeColor,
    this.discountTypeName,
    this.paidBonus,
    this.totalBonus,
    //
    this.priceWithDiscount,
    this.totalAmountWithDiscount,
    this.price,
    this.originalPrice,
  });

  dynamic uuid;
  dynamic orderUuid;
  String productUuid;
  OrderCalculateAssortmentModel assortment;
  var quantity;
  int rating;
  String ratingComment;
  double totalWeight;
  //
  double priceWithDiscount;
  double totalAmountWithDiscount;
  double price;
  double originalPrice;
  //
  double discount;
  double totalDiscount;
  String createdAt;
  String updatedAt;
  String discountableType;
  String discountTypeColor;
  String discountTypeName;
  double paidBonus;
  double totalBonus;

  factory OrderCalculateProductModel.fromJson(Map<String, dynamic> json) => OrderCalculateProductModel(
        uuid: json["uuid"],
        paidBonus: double.tryParse(json["paid_bonus"].toString()),
        totalBonus: double.tryParse(json["total_bonus"].toString()),
        rating: json["rating"],
        ratingComment: json["rating_comment"],
        orderUuid: json["order_uuid"],
        productUuid: json["product_uuid"],
        assortment: OrderCalculateAssortmentModel.fromJson(json["assortment"]),
        quantity: json["quantity"],
        totalWeight: json["total_weight"].toDouble(),
        discount: json["discount"].toDouble(),
        totalDiscount: json["total_discount"].toDouble(),
        discountableType: json["discountable_type"],
        discountTypeName: json["discount_type_name"],
        discountTypeColor: json["discount_type_color"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        //
        priceWithDiscount: json["price_with_discount"] == null ? null : double.parse(json["price_with_discount"].toString()),
        totalAmountWithDiscount: json["total_amount_with_discount"].toDouble(),
        price: json["price"] == null ? null : double.parse(json["price"].toString()),
        originalPrice: json["original_price"] == null ? null : double.parse(json["original_price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "total_bonus": totalBonus,
        "paid_bonus": paidBonus,
        "order_uuid": orderUuid,
        "product_uuid": productUuid,
        "assortment": assortment.toJson(),
        "quantity": quantity,
        "total_weight": totalWeight,
        "discount": discount,
        "total_discount": totalDiscount,
        "discountable_type": discountableType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        //
        "price_with_discount": priceWithDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "price": price,
        "original_price": originalPrice,
      };
}

class OrderCalculateAssortmentModel {
  OrderCalculateAssortmentModel(
      {this.uuid, this.name, this.catalogUuid, this.catalogName, this.rating, this.assortmentWeight, this.images, this.assortmentUnitId});

  String uuid;
  String name;
  String assortmentUnitId;
  double assortmentWeight;

  String catalogUuid;
  String catalogName;
  double rating;
  List<ImageModel> images;

  factory OrderCalculateAssortmentModel.fromJson(Map<String, dynamic> json) => OrderCalculateAssortmentModel(
        uuid: json["uuid"],
        assortmentUnitId: json["assortment_unit_id"],
        name: json["name"],
        assortmentWeight: double.tryParse(json["assortment_weight"].toString()),
        catalogUuid: json["catalog_uuid"],
        catalogName: json["catalog_name"],
        rating: json["rating"] == null ? null : double.parse(json["rating"].toString()),
        images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "assortment_weight": assortmentWeight,
        "name": name,
        "assortment_unit_id": assortmentUnitId,
        "catalog_uuid": catalogUuid,
        "catalog_name": catalogName,
        "rating": rating,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}
