import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class InitAddUserAddressItem extends StatelessWidget {
  final bool isActive;
  final String name;
  final String nameId;
  final String time;
  final String price;
  final String thumbnail;

  const InitAddUserAddressItem({Key key, @required this.isActive, @required this.name, @required this.time, @required this.price, @required this.thumbnail, @required this.nameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? newRedDark : Colors.transparent),
        color: whiteColor,
        borderRadius: BorderRadius.circular(heightRatio(size: 5, context: context)),
        boxShadow: [BoxShadow(color: newShadow, offset: Offset(2, 2), blurRadius: 4, spreadRadius: 0)],
      ),
      margin: EdgeInsets.only(top: heightRatio(size: 20, context: context)),
      padding: EdgeInsets.symmetric(vertical: heightRatio(size: 13, context: context), horizontal: widthRatio(size: 9, context: context)),
      child: Row(
        children: [
          thumbnail != ""
              ? Image.network(
                  thumbnail,
                  fit: BoxFit.scaleDown,
                  width: widthRatio(size: 51, context: context),
                  height: heightRatio(size: 42, context: context),
                )
              : SizedBox(width: widthRatio(size: 51.5, context: context)),
          SizedBox(width: widthRatio(size: 7, context: context)),
          Container(
            width: MediaQuery.of(context).size.width - widthRatio(size: 114, context: context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: appLabelTextStyle(
                    fontSize: heightRatio(size: 12, context: context),
                    color: newBlack,
                  ),
                ),
                // Text(
                //   nameId,
                //   style: appLabelTextStyle(
                //     fontSize: heightRatio(size: 12, context: context),
                //     color: newBlack,
                //   ),
                // ),
                SizedBox(height: heightRatio(size: 9, context: context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/newMoto.svg',
                          color: newRedDark,
                          height: heightRatio(size: 12, context: context),
                          width: widthRatio(size: 18, context: context),
                        ),
                        SizedBox(width: widthRatio(size: 9, context: context)),
                        Text(
                          time,
                          style: appLabelTextStyle(
                            fontSize: heightRatio(size: 12, context: context),
                            color: newRedDark,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$price ',
                            style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: newRedDark),
                          ),
                          TextSpan(
                            style: appTextStyle(fontSize: heightRatio(size: 12, context: context), color: newRedDark),
                            text: '₽',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
