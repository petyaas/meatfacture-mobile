import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/models/catalog_list_model.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
import 'package:smart/features/catalog/widgets/Catalog_card_widget.dart';
import 'package:flutter/cupertino.dart';

class CatalogLevelsWidget extends StatelessWidget {
  final bool isFromFavCatalogsList;
  final CatalogListModel catalogListModel;

  const CatalogLevelsWidget({this.catalogListModel, @required this.isFromFavCatalogsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          catalogListModel.name,
          style: appHeadersTextStyle(fontSize: heightRatio(size: 16, context: context), color: Colors.black),
        ),
        SizedBox(height: 16),
        if (catalogListModel.subcatalog != null && catalogListModel.subcatalog.length != null && catalogListModel.subcatalog.length > 0)
          GridView.builder(
            padding: EdgeInsets.only(top: 0, bottom: 12),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.64,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
            ),
            itemCount: catalogListModel.subcatalog?.length ?? 0,
            itemBuilder: (context, subIndex) {
              var subCatalog = catalogListModel.subcatalog[subIndex];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SubcatalogScreen(
                        tagsListFromCatalog: subCatalog.assortmentsTagsInStore,
                        isSearchPage: false,
                        preCataloName: subCatalog.name,
                        preCataloUuid: subCatalog.uuid,
                        isFinalLevel: subCatalog.isFinalLevel,
                        isFromFavCatalogsList: isFromFavCatalogsList,
                      ),
                    ),
                  );
                },
                child: CatalogsCardWidget(catalogListModel: subCatalog),
              );
            },
          ),
      ],
    );
  }
}
