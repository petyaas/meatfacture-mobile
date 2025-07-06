import 'package:flutter/material.dart';
import 'package:smart/core/constants/source.dart';

class CustomLoadableScreen extends StatefulWidget {
  CustomLoadableScreen({
    @required this.child,
    this.loading = false,
  });

  final Widget child;
  final bool loading;

  @override
  _CustomLoadableScreenState createState() => _CustomLoadableScreenState();
}

class _CustomLoadableScreenState extends State<CustomLoadableScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: widget.child,
        ),
        if (widget.loading)
          Positioned(
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: screenHeight(context),
              width: screenWidth(context),
              decoration: BoxDecoration(
                color: colorBlack03,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
