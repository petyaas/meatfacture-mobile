// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModelForOrderRequest {
  double quantity;
  String assortmentUuid;
  ProductModelForOrderRequest({this.quantity, this.assortmentUuid});

  factory ProductModelForOrderRequest.fromJson(Map<String, dynamic> json) => ProductModelForOrderRequest(
        assortmentUuid: json["assortment_uuid"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "assortment_uuid": assortmentUuid,
      };

  @override
  String toString() => 'ProductModelForOrderRequest(quantity: $quantity, assortmentUuid: $assortmentUuid)';
}
