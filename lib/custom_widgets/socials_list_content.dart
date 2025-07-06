import 'package:flutter/material.dart';
import 'package:smart/models/socials_list_model.dart';
import 'package:smart/core/constants/source.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialsListContent extends StatelessWidget {
  final SocialsListModel socialsListModel;

  const SocialsListContent({@required this.socialsListModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: socialsListModel.data.length),
        itemCount: socialsListModel.data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              launchUrl(Uri.parse(socialsListModel.data[index].url), mode: LaunchMode.externalApplication);
            },
            child: Container(
              margin: EdgeInsets.only(right: widthRatio(size: index + 1 != socialsListModel.data.length ? 5 : 0, context: context), left: widthRatio(size: index != 0 ? 5 : 0, context: context)),
              child: Image.network(
                socialsListModel.data[index].logoFilePath,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
