// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/im_in_shop_bloc.dart';
import 'package:smart/custom_widgets/redesigned_widgets/redes_assortments_card2_widget.dart';
import 'package:smart/models/assortments_list_model.dart';
import 'package:smart/models/im_in_shop_model.dart';
import 'package:smart/core/constants/source.dart';

// ignore: must_be_immutable
class RedesImInShopAssortmentsListWidget extends StatefulWidget {
  @override
  State<RedesImInShopAssortmentsListWidget> createState() => _RedesImInShopAssortmentsListWidgetState();
}

class _RedesImInShopAssortmentsListWidgetState extends State<RedesImInShopAssortmentsListWidget> {
  int i = 1;
  final List<String> _imInShopAssortmentList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImInShopBloc, ImInShopState>(builder: (context, state) {
      if (state is ImInShopLoadedState) {
        i = 1;
        _imInShopAssortmentList.clear();
        for (var i = 0; i < state.imInShopModel.data.products.length; i++) {
          _imInShopAssortmentList.add(state.imInShopModel.data.products[i].uuid);
        }
        return Container(
          clipBehavior: Clip.none,
          color: Colors.transparent,
          height: !state.imInShopModel.data.products.isEmpty ? screenWidth(context) / 2.9 : 0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: state.imInShopModel.data.products.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.only(top: 7),
              width: (screenWidth(context) / 2.1) - widthRatio(size: 5, context: context),
              child: RedesAssortmentsCard2Widget(
                isRecomendations: false,
                assortmentsListModel: mapImInShopProductToAssortmentProduct(product: state.imInShopModel.data.products[index]),
              ),
            ),
          ),
        );
      }
      return SizedBox();
    });
  }
}

mapImInShopProductToAssortmentProduct({Product product}) {
  return AssortmentsListModel(
    uuid: product.uuid,
    totalBonus: product.totalBonus.toDouble(),
    quantityInClientCart: product.quantityInClientCart,
    assortmentUnitId: product.assortmentUnitId,
    shortName: product.name,
    weight: product.weight,
    name: product.name,
    rating: product.rating == null ? null : product.rating.value,
    images: product.images,
    currentPrice: product.price.toString(),
    priceWithDiscount: product.priceWithDiscount,
    discountType: product.discountType,
    discountTypeColor: product.discountTypeColor,
    discountTypeName: product.discountTypeName,
    productsQuantity: product.quantity,
  );
}
