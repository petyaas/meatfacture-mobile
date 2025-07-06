import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
// import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SocialNetworkIcon extends StatelessWidget {
  final Color bgColor;
  final String sNetwIconAsset;
  const SocialNetworkIcon({@required this.bgColor, @required this.sNetwIconAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widthRatio(size: 15, context: context)),
      height: heightRatio(size: 60, context: context),
      width: widthRatio(size: 60, context: context),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(heightRatio(size: 10, context: context))),
      child: Container(
        child: SvgPicture.asset(sNetwIconAsset),
      ),
    );
  }
}
