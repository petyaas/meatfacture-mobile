// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/tags_bloc.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';

class CatalogTegsWidget extends StatefulWidget {
  const CatalogTegsWidget({Key key}) : super(key: key);

  @override
  _CatalogTegsWidgetState createState() => _CatalogTegsWidgetState();
}

class _CatalogTegsWidgetState extends State<CatalogTegsWidget> {
  List<String> activeTagsList = [];

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    // CatalogsBloc _catalogsBloc = BlocProvider.of<CatalogsBloc>(context);
    return BlocBuilder<TagsBloc, TagsState>(builder: (context, state) {
      if (state is TagsErrorState) {
        return Container(
            height: heightRatio(size: 25, context: context),
            child: Center(
              child: Text('errorText'.tr()),
            ));
      }
      if (state is TagsLoadingState) {
        return SizedBox();
      }
      if (state is TagsLoadedState) {
        return Container(
          height: heightRatio(size: 30, context: context),
          child: Center(
              child: ListView.builder(
                  padding: EdgeInsets.only(left: widthRatio(size: 10, context: context)),
                  itemCount: state.tagsModel.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubcatalogScreen(
                                isSearchPage: false,
                                activeTagsList: [state.tagsModel.data[index].name],
                                preCataloName: state.tagsModel.data[index].name,
                              ),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 10, context: context)),
                        margin: EdgeInsets.symmetric(horizontal: widthRatio(size: 5, context: context)),
                        decoration: BoxDecoration(color: greyForTegs, borderRadius: BorderRadius.circular(heightRatio(size: 50, context: context))),
                        alignment: Alignment.center,
                        child: Text(
                          state.tagsModel.data[index].name,
                          style: appTextStyle(fontSize: heightRatio(size: 14, context: context), fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  })),
        );
      }
      if (state is TagsEmptyState) {
        return SizedBox();
      }

      return SizedBox();
    });
  }
}
