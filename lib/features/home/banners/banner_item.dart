import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/secondary_pages_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/features/home/models/banners_list_model.dart';
import 'package:smart/pages/redesigned_pages/redes_product_details_page.dart';
import 'package:smart/utils/custom_cache_manager.dart';

class BannerItem extends StatelessWidget {
  final BannersListDataModel bannersListDataModel;
  const BannerItem({@required this.bannersListDataModel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (bannersListDataModel.referenceType == "product") {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RedesProductDetailsPage(
                productUuid: bannersListDataModel.referenceUuid,
              ),
            ),
          );
        } else if (bannersListDataModel.referenceType == "catalog") {
          if (bannersListDataModel.referenceUuid != null && bannersListDataModel.referenceUuid != "") {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SubcatalogScreen(
                  tagsListFromCatalog: null,
                  isSearchPage: false,
                  preCataloName: "Категория",
                  preCataloUuid: bannersListDataModel.referenceUuid,
                  isFinalLevel: true,
                ),
              ),
            );
          } else {
            BlocProvider.of<SecondaryPageBloc>(context).add(CatalogEvent());
          }
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            width: double.maxFinite,
            height: heightRatio(size: 165, context: context),
            imageUrl: bannersListDataModel.logoFilePath,
            cacheManager: CustomCacheManager(),
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Image.asset("assets/images/notImage.png", fit: BoxFit.contain),
          ),
          if ((bannersListDataModel.name != null && bannersListDataModel.name != "") || (bannersListDataModel.description != null && bannersListDataModel.description != ""))
            Positioned(
              top: heightRatio(size: 24, context: context),
              left: widthRatio(size: 16, context: context),
              child: SizedBox(
                width: widthRatio(size: 210, context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bannersListDataModel.name != null && bannersListDataModel.name != "")
                      Text(
                        bannersListDataModel.name,
                        style: appHeadersTextStyle(color: Colors.white, fontSize: heightRatio(size: 20, context: context)),
                      ),
                    SizedBox(height: heightRatio(size: 10, context: context)),
                    if (bannersListDataModel.description != null && bannersListDataModel.description != "")
                      Text(
                        bannersListDataModel.description,
                        style: appLabelTextStyle(color: Colors.white, fontSize: heightRatio(size: 15, context: context)),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
