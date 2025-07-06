import 'package:flutter/material.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/features/recipes/widgets/recipe_card_widget.dart';

class RecipesCarousel extends StatelessWidget {
  final ReceiptsListModel receiptsList;
  const RecipesCarousel({this.receiptsList});

  @override
  Widget build(BuildContext context) {
    List<Datum> filteredData = receiptsList.data.where((item) => !item.isFavorite).toList();
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      height: heightRatio(size: 140, context: context),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 16, context: context)),
          scrollDirection: Axis.horizontal,
          itemCount: filteredData.length > 10 ? 10 : filteredData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(
            width: widthRatio(size: 11, context: context),
          ),
          itemBuilder: (context, index) => RecipesCardWidget(recipe: filteredData[index]),
        ),
      ),
    );
  }
}
