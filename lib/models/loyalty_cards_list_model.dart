import 'package:smart/models/lyalty_cards_list_data_model.dart';
import 'package:smart/models/meta_model.dart';

class LoyaltyCardsListModel {
  LoyaltyCardsListModel({
    this.data,
    this.meta,
  });

  List<LoyaltyCardsListDataModel> data;
  MetaModel meta;

  factory LoyaltyCardsListModel.fromJson(Map<String, dynamic> json) =>
      LoyaltyCardsListModel(
        data: List<LoyaltyCardsListDataModel>.from(
            json["data"].map((x) => LoyaltyCardsListDataModel.fromJson(x))),
        meta: MetaModel.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}
