import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class ProductIngredientMiddleContent extends StatefulWidget {
  final String ingredients;
  final String weght;
  const ProductIngredientMiddleContent({this.ingredients, this.weght});

  @override
  State<ProductIngredientMiddleContent> createState() => _ProductIngredientMiddleContentState();
}

class _ProductIngredientMiddleContentState extends State<ProductIngredientMiddleContent> {
  String readyIngredients;
  List<String> ingredientsList = [];

  List<String> ingredientsNumbersList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      readyIngredients = widget.ingredients;

      ingredientsList = widget.ingredients.split(";");

      if (ingredientsList.isNotEmpty) {
        ingredientsList[0] = ingredientsList[0].replaceAll("Состав:  ", "");
      }
      for (var i = 0; i < ingredientsList.length; i++) {
        ingredientsNumbersList.add(ingredientsList[i].replaceAll(new RegExp(r'[^0,0-9,9]'), ''));
        ingredientsList[i] = ingredientsList[i].replaceAll(RegExp(r'[0-9]'), "").replaceAll(",", '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ingredientsList[0].isNotEmpty)
          Text(ingredientsList[0],
              style: appTextStyle(
                fontSize: heightRatio(size: 14, context: context),
                fontWeight: FontWeight.w500,
              )),
        if (ingredientsList[0].isNotEmpty) Divider(),
        if (ingredientsNumbersList.length > 1)
          for (var i = 1; i < ingredientsNumbersList.length; i++)
            Row(children: [
              Text(ingredientsList[i],
                  style: appTextStyle(
                    fontSize: heightRatio(size: 14, context: context),
                    fontWeight: FontWeight.w700,
                  )),
              Text(ingredientsNumbersList[i],
                  style: appTextStyle(
                    fontSize: heightRatio(size: 14, context: context),
                    fontWeight: FontWeight.w500,
                  )),
            ])
        else if (ingredientsNumbersList.length == 1)
          Text(ingredientsNumbersList[0],
              style: appTextStyle(
                fontSize: heightRatio(size: 14, context: context),
                fontWeight: FontWeight.w500,
              )),
      ],
    );
  }
}
