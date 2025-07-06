// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:smart/bloc_files/brands_bloc.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';
// import 'package:smart/bloc_files/catalogs_bloc.dart';
import 'package:smart/models/assortment_brands_list_model.dart';
import 'package:smart/services/services.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

// ignore: must_be_immutable
class AssortmentBrandFilterBottomSheet extends StatefulWidget {
  @override
  _AssortmentBrandFilterBottomSheetState createState() => _AssortmentBrandFilterBottomSheetState();
}

class _AssortmentBrandFilterBottomSheetState extends State<AssortmentBrandFilterBottomSheet> {
  int i = 1;
  final TextEditingController searchTextController = TextEditingController();
  List<String> _brandsUuidToSend = [];

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    BrandBloc _brandBloc = BlocProvider.of<BrandBloc>(context);
    // ignore: close_sinks
    // CatalogsBloc _catalogsBloc = BlocProvider.of<CatalogsBloc>(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(heightRatio(size: 15, context: context)),
        topRight: Radius.circular(heightRatio(size: 15, context: context)),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: widthRatio(size: 15, context: context),
          right: widthRatio(size: 15, context: context),
          bottom: MediaQuery.of(context).viewInsets.bottom == 0
              ? MediaQuery.of(context).viewInsets.bottom
              : MediaQuery.of(context).viewInsets.bottom -
                  heightRatio(
                    size: 50,
                    context: context,
                  ),
        ),
        height: screenHeight(context) * 0.75,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: heightRatio(size: 15, context: context)),
            Text(
              "brandsText".tr(),
              style: appTextStyle(fontSize: heightRatio(size: 24, context: context)),
            ),

            SizedBox(height: heightRatio(size: 10, context: context)),
            //search field
            Container(
              child: TextField(
                onChanged: (value) {
                  _brandBloc.add(BrandLoadEvent());
                },
                controller: searchTextController,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search_outlined), border: InputBorder.none, hintText: "Найти бренд"),
              ),
              // padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context)), color: colorBlack03),
            ),
            BlocBuilder<BrandBloc, BrandState>(
              builder: (context, state) {
                if (state is BrandLoadedState) {
                  i = 1;
                  return Expanded(
                    child: Container(
                      // color: Colors.amber,
                      height: heightRatio(size: 170, context: context),
                      alignment: Alignment.centerLeft,
                      child: PaginationView<AssortmentBrandsListDatamodel>(
                          padding: EdgeInsets.only(top: heightRatio(size: 10, context: context)),
                          itemBuilder: (context, AssortmentBrandsListDatamodel _assortmentBrandsListDatamodel, int index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_assortmentBrandsListDatamodel.isSelected) {
                                      _assortmentBrandsListDatamodel.isSelected = false;
                                      _brandsUuidToSend.remove(_assortmentBrandsListDatamodel.uuid);
                                    } else {
                                      _brandsUuidToSend.add(_assortmentBrandsListDatamodel.uuid);
                                      _assortmentBrandsListDatamodel.isSelected = true;
                                    }
                                  });

                                  // Navigator.pop(context);

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           AssortmentsListPage(
                                  //         isSearchPage: false,
                                  //         brandName:
                                  //             _assortmentBrandsListDatamodel
                                  //                 .name,
                                  //         preCataloName:
                                  //             _assortmentBrandsListDatamodel
                                  //                 .name,
                                  //       ),
                                  //     ));
                                },
                                child: Container(
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: heightRatio(size: 5, context: context)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_assortmentBrandsListDatamodel.name, style: notEmptyHintTextStyle),
                                              Checkbox(
                                                  fillColor: MaterialStateProperty.all(mainColor),
                                                  value: _assortmentBrandsListDatamodel.isSelected,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      _assortmentBrandsListDatamodel.isSelected = value;

                                                      setState(() {
                                                        if (!value) {
                                                          _brandsUuidToSend.remove(_assortmentBrandsListDatamodel.uuid);
                                                        } else {
                                                          _brandsUuidToSend.add(_assortmentBrandsListDatamodel.uuid);
                                                        }
                                                      });
                                                    });
                                                  })
                                            ],
                                          ),
                                          SizedBox(height: heightRatio(size: 5, context: context)),
                                          Divider()
                                        ],
                                      )),
                                ),
                              ),
                          onEmpty: Container(),
                          pageFetch: (currentListSize) async {
                            AssortmentBrandsListmodel _brandsList = await AssortmentBrandsProvider().getAssortmentBrandsResponse(page: i, searchText: searchTextController.text != "" ? searchTextController.text : null);
                            i++;
                            return _brandsList.data;
                          },
                          onError: (error) => Container(child: Text("errorText".tr()))),
                    ),
                  );
                }
                return Container(
                  height: heightRatio(size: 170, context: context),
                );
              },
            ),
            SizedBox(height: heightRatio(size: 10, context: context)),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                if (_brandsUuidToSend.isEmpty) {
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubcatalogScreen(isSearchPage: false, brandName: _brandsUuidToSend, preCataloName: "brandsText".tr()),
                      ));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: heightRatio(size: 15, context: context)),
                alignment: Alignment.center,
                child: Text("applyText".tr(), style: appTextStyle(fontSize: heightRatio(size: 18, context: context), color: Colors.white)),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context)), color: mainColor),
              ),
            ),
            SizedBox(height: heightRatio(size: 10, context: context)),
          ],
        ),
      ),
    );
  }
}
