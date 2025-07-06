import 'package:flutter/material.dart';
import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogsCardWidget extends StatelessWidget {
  final CatalogListModel catalogListModel;

  const CatalogsCardWidget({this.catalogListModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //категории
          width: double.maxFinite,
          height: heightRatio(size: 136, context: context),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: catalogListModel.image == null || catalogListModel.image.path == null || catalogListModel.image.path == '' ? newGrey2 : Colors.transparent,
            borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
            child: catalogListModel.image != null
                ? CachedNetworkImage(
                    imageUrl: catalogListModel.image.path,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat,
                    errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
                    useOldImageOnUrlChange: true,
                  )
                : Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: heightRatio(size: 4, context: context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "${catalogListModel.name}" + "\n",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newBlack),
          ),
        ),
        // Text(
        //   catalogListModel.assortmentsCountInStore != null
        //       ? catalogListModel.assortmentsCountInStore.toString() +
        //           " " +
        //           "товаров" //кол-во товаров
        //       : "",
        //   style: appTextStyle(
        //       color: colorBlack04,
        //       fontSize: heightRatio(size: 12, context: context)),
        // ),
      ],
    );
  }
}
