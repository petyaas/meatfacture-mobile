import 'package:smart/models/create_order_response_model.dart';

class OrderProcessItemModel {
  String uuid;
  int number;
  String storeUserUuid;
  String storeUserFullName;
  String storeUserAddress;
  String storePhone;
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
  String courierPhone;
  double totalPrice;
  double totalWeight;
  double totalQuantity;
  double totalBonus;
  double paidBonus;
  double bonusToCharge;
  String plannedDeliveryDatetimeFrom;
  String plannedDeliveryDatetimeTo;
  String createdAt;
  String updatedAt;
  String promocode;

  OrderProcessItemModel({
    this.uuid,
    this.number,
    this.storeUserUuid,
    this.storeUserFullName,
    this.storeUserAddress,
    this.storePhone,
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
    this.courierPhone,
    this.totalPrice,
    this.totalWeight,
    this.totalQuantity,
    this.totalBonus,
    this.paidBonus,
    this.bonusToCharge,
    this.plannedDeliveryDatetimeFrom,
    this.plannedDeliveryDatetimeTo,
    this.createdAt,
    this.updatedAt,
    this.promocode,
  });

  factory OrderProcessItemModel.fromJson(Map<String, dynamic> json) => OrderProcessItemModel(
        uuid: json["uuid"],
        number: json["number"],
        storeUserUuid: json["store_user_uuid"],
        storeUserFullName: json["store_user_full_name"],
        storeUserAddress: json["store_user_address"],
        storePhone: json["store_phone"],
        orderStatusId: json["order_status_id"],
        orderDeliveryTypeId: json["order_delivery_type_id"],
        orderPaymentTypeId: json["order_payment_type_id"],
        clientComment: json["client_comment"],
        clientEmail: json["client_email"],
        clientAddressData: json["clientAddressData"] == null ? null : OrderClientAddressDataModel.fromJson(json["client_address_data"]),
        isPaid: json["is_paid"],
        deliveryPrice: _toDouble(json["delivery_price"]),
        totalDiscountForProducts: _toDouble(json["total_discount_for_products"]),
        totalPriceForProductsWithDiscount: _toDouble(json["total_price_for_products_with_discount"]),
        courierPhone: json["courier_phone"],
        totalPrice: _toDouble(json["total_price"]),
        totalWeight: _toDouble(json["total_weight"]),
        totalQuantity: _toDouble(json["total_quantity"]),
        totalBonus: _toDouble(json["total_bonus"]),
        paidBonus: _toDouble(json["paid_bonus"]),
        bonusToCharge: _toDouble(json["bonus_to_charge"]),
        plannedDeliveryDatetimeFrom: json["planned_delivery_datetime_from"],
        plannedDeliveryDatetimeTo: json["planned_delivery_datetime_to"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        promocode: json["promocode"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "number": number,
        "store_user_uuid": storeUserUuid,
        "store_user_full_name": storeUserFullName,
        "store_user_address": storeUserAddress,
        "store_phone": storePhone,
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
        "courier_phone": courierPhone,
        "total_price": totalPrice,
        "total_weight": totalWeight,
        "total_quantity": totalQuantity,
        "total_bonus": totalBonus,
        "paid_bonus": paidBonus,
        "bonus_to_charge": bonusToCharge,
        "planned_delivery_datetime_from": plannedDeliveryDatetimeFrom,
        "planned_delivery_datetime_to": plannedDeliveryDatetimeTo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "promocode": promocode,
      };
}

double _toDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    throw FormatException('Invalid value: $value. Expected int or double.');
  }
}
