import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/custom_widgets/order_calculate_bottom_sheet.dart';
import 'package:smart/models/product_model_for_order_request.dart';

void openOrderCalculateBottomSheet({
  @required String clientCreditCardUuid,
  @required BuildContext context,
  @required String clientComment,
  @required String clientEmail,
  @required String address,
  @required int floor,
  @required int entrance,
  @required int apartmentNumber,
  @required String intercomCode,
  @required String plannedDeliveryDatetimeFrom,
  @required String plannedDeliveryDatetimeTo,
  @required String orderDeliveryTypeId,
  @required String orderPaymentTypeId,
  @required List<ProductModelForOrderRequest> productModelForOrderRequestList,
}) {
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 25, context: context)),
        topRight: Radius.circular(heightRatio(size: 25, context: context)),
      ),
    ),
    builder: (BuildContext bc) {
      debugPrint("🍏 clientCreditCardUuid: $clientCreditCardUuid");
      debugPrint('🍏 clientComment: $clientComment');
      debugPrint('🍏 clientEmail: $clientEmail');
      debugPrint('🍏 address: $address');
      debugPrint('🍏 floor: $floor');
      debugPrint('🍏 entrance: $entrance');
      debugPrint('🍏 apartmentNumber: $apartmentNumber');
      debugPrint('🍏 intercomCode: $intercomCode');
      debugPrint('🍏 plannedDeliveryDatetimeFrom: $plannedDeliveryDatetimeFrom');
      debugPrint('🍏 plannedDeliveryDatetimeTo: $plannedDeliveryDatetimeTo');
      debugPrint('🍏 orderDeliveryTypeId: $orderDeliveryTypeId');
      debugPrint('🍏 orderPaymentTypeId: $orderPaymentTypeId');
      debugPrint('🍏 productModelForOrderRequestList: $productModelForOrderRequestList');

      return Wrap(
        children: [
          OrderCalculateBottomSheet(
            clientCreditCardUuid: clientCreditCardUuid,
            apartmentNumber: apartmentNumber,
            clientComment: clientComment,
            clientEmail: clientEmail,
            entrance: entrance,
            floor: floor,
            intercomCode: intercomCode == "" ? "none" : intercomCode,
            orderDeliveryTypeId: orderDeliveryTypeId,
            orderPaymentTypeId: orderPaymentTypeId,
            plannedDeliveryDatetimeFrom: plannedDeliveryDatetimeFrom,
            plannedDeliveryDatetimeTo: plannedDeliveryDatetimeTo,
            productModelForOrderRequestList: productModelForOrderRequestList,
            address: address,
          ),
        ],
      );
    },
  );
}
