import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/core/constants/source.dart';

class SecondItemCard extends StatelessWidget {
  final Color elipsColor;
  final String label;
  final String imageAsset;

  const SecondItemCard({@required this.label, @required this.elipsColor, @required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 6, top: 10),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      shadowColor: colorBlack04,
      child: Container(
        height: 135,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 15, right: 5),
                child: Text(
                  label,
                  style: GoogleFonts.raleway(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        'assets/images/littleElips.svg',
                        color: elipsColor,
                      ),
                      Positioned(left: 50, bottom: 10, child: SvgPicture.asset(imageAsset)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
