import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/features/recipes/models/receipts_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/recipes/recipes_detail_screen.dart';

class RecipesCardWidget extends StatelessWidget {
  const RecipesCardWidget({this.recipe});
//сторисы
  final Datum recipe;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)));
      },
      child: SizedBox(
        width: widthRatio(size: 161, context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widthRatio(size: 161, context: context),
              height: heightRatio(size: 104, context: context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(heightRatio(size: 7, context: context)),
                image: DecorationImage(
                  image: NetworkImage(recipe.filePath != null ? recipe.filePath : ''),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightRatio(size: 7, context: context)),
                  color: colorBlack06,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/newPlay.svg",
                  height: heightRatio(size: 30, context: context),
                  width: widthRatio(size: 30, context: context),
                ),
              ),
            ),
            SizedBox(height: heightRatio(size: 8, context: context)),
            Flexible(
              child: Text(
                recipe.name != null ? recipe.name : '',
                style: appLabelTextStyle(color: newBlack, fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
