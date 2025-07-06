import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/features/catalog/subcatalog_screen.dart';

class TagsListInAssortments extends StatelessWidget {
  final List<String> tagsList;
  const TagsListInAssortments({Key key, @required this.tagsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthRatio(size: 15, context: context)),
      height: heightRatio(size: 30, context: context),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        children: tagsList.map((e) => _TagsItem(e)).toList(),
      ),
    );
  }
}

class _TagsItem extends StatelessWidget {
  final String tag;
  const _TagsItem(this.tag, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubcatalogScreen(
                isSearchPage: false,
                activeTagsList: [tag],
                preCataloName: tag,
              ),
            ));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: widthRatio(size: 8, context: context),
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: greyForTegs),
        child: Text(tag, style: appTextStyle(fontSize: heightRatio(size: 14, context: context))),
      ),
    );
  }
}
