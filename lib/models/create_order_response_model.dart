import 'order_calculate_response_model.dart';

class OrderCreateResponseModel {
  OrderCreateResponseModel({
    this.data,
  });

  CreateOrderResponseDataModel data;

  factory OrderCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderCreateResponseModel(
        data: CreateOrderResponseDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class CreateOrderResponseDataModel {
  CreateOrderResponseDataModel({
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
    this.deliveryPrice,
    this.totalDiscountForProducts,
    this.totalPriceForProductsWithDiscount,
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
  });

  int number;
  String uuid;
  String storeUserUuid;
  String storeUserFullName;
  String storeUserAddress;
  String orderStatusId;
  String orderDeliveryTypeId;
  String orderPaymentTypeId;
  String clientComment;
  String clientEmail;
  OrderClientAddressDataModel clientAddressData;
  bool isPaid;
  double deliveryPrice;
  double totalDiscountForProducts;
  double totalPriceForProductsWithDiscount;
  double totalPrice;
  double totalWeight;
  double totalQuantity;
  String plannedDeliveryDatetimeFrom;
  String plannedDeliveryDatetimeTo;
  String createdAt;
  String updatedAt;
  List<OrderProductModel> products;
  int totalBonus;
  int paidBonus;
  int bonusToCharge;
  int maxBonusToPaid;

  factory CreateOrderResponseDataModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseDataModel(
        uuid: json["uuid"],
        totalBonus: json["total_bonus"],
        maxBonusToPaid: json["max_bonus_to_paid"],
        bonusToCharge: json["bonus_to_charge"],
        paidBonus: json["paid_bonus"],
        storeUserUuid: json["store_user_uuid"],
        storeUserFullName: json["store_user_full_name"],
        storeUserAddress: json["store_user_address"],
        orderStatusId: json["order_status_id"],
        orderDeliveryTypeId: json["order_delivery_type_id"],
        orderPaymentTypeId: json["order_payment_type_id"],
        clientComment: json["client_comment"],
        clientEmail: json["client_email"],
        number: json["number"] == null ? null : json["number"],
        clientAddressData: json["clientAddressData"] == null
            ? null
            : OrderClientAddressDataModel.fromJson(json["client_address_data"]),
        isPaid: json["is_paid"],
        deliveryPrice: json["delivery_price"].toDouble(),
        totalDiscountForProducts:
            json["total_discount_for_products"].toDouble(),
        totalPriceForProductsWithDiscount:
            json["total_price_for_products_with_discount"] == null
                ? null
                : double.parse(
                    json["total_price_for_products_with_discount"].toString()),
        totalPrice: json["total_price"].toDouble(),
        totalWeight: json["total_weight"].toDouble(),
        totalQuantity: json["total_quantity"] == null
            ? null
            : double.parse(json["total_quantity"].toString()),
        plannedDeliveryDatetimeFrom: json["planned_delivery_datetime_from"],
        plannedDeliveryDatetimeTo: json["planned_delivery_datetime_to"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        products: List<OrderProductModel>.from(
            json["products"].map((x) => OrderProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
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
        "number": number == null ? null : number,
        "client_address_data":
            clientAddressData == null ? null : clientAddressData.toJson(),
        "is_paid": isPaid,
        "delivery_price": deliveryPrice,
        "total_discount_for_products": totalDiscountForProducts,
        "total_price_for_products_with_discount":
            totalPriceForProductsWithDiscount,
        "total_price": totalPrice,
        "total_weight": totalWeight,
        "total_quantity": totalQuantity,
        "planned_delivery_datetime_from": plannedDeliveryDatetimeFrom,
        "planned_delivery_datetime_to": plannedDeliveryDatetimeTo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class OrderClientAddressDataModel {
  OrderClientAddressDataModel({
    this.address,
    this.floor,
    this.entrance,
    this.apartmentNumber,
    this.intercomCode,
  });

  String address;
  int floor;
  int entrance;
  int apartmentNumber;
  String intercomCode;

  factory OrderClientAddressDataModel.fromJson(Map<String, dynamic> json) =>
      OrderClientAddressDataModel(
        address: json["address"],
        floor: json["floor"],
        entrance: json["entrance"],
        apartmentNumber: json["apartment_number"],
        intercomCode: json["intercom_code"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "floor": floor,
        "entrance": entrance,
        "apartment_number": apartmentNumber,
        "intercom_code": intercomCode,
      };
}

class OrderProductModel {
  OrderProductModel({
    this.uuid,
    this.orderUuid,
    this.productUuid,
    this.assortment,
    this.quantity,
    this.totalWeight,
    this.priceWithDiscount,
    this.discount,
    this.totalDiscount,
    this.totalAmountWithDiscount,
    this.discountableType,
    this.createdAt,
    this.updatedAt,
  });

  String uuid;
  String orderUuid;
  String productUuid;
  OrderCalculateAssortmentModel assortment;
  double quantity;
  double totalWeight;
  double priceWithDiscount;
  double discount;
  double totalDiscount;
  double totalAmountWithDiscount;
  String discountableType;
  String createdAt;
  String updatedAt;

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        uuid: json["uuid"],
        orderUuid: json["order_uuid"],
        assortment: OrderCalculateAssortmentModel.fromJson(json["assortment"]),
        productUuid: json["product_uuid"],
        quantity: json["quantity"] == null
            ? null
            : double.parse(json["quantity"].toString()),
        totalWeight: json["total_weight"].toDouble(),
        priceWithDiscount: json["price_with_discount"].toDouble(),
        discount: json["discount"].toDouble(),
        totalDiscount: json["total_discount"].toDouble(),
        totalAmountWithDiscount: json["total_amount_with_discount"].toDouble(),
        discountableType: json["discountable_type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "order_uuid": orderUuid,
        "product_uuid": productUuid,
        "assortment": assortment.toJson(),
        "quantity": quantity,
        "total_weight": totalWeight,
        "price_with_discount": priceWithDiscount,
        "discount": discount,
        "total_discount": totalDiscount,
        "total_amount_with_discount": totalAmountWithDiscount,
        "discountable_type": discountableType,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
