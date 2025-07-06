import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/core/formatters/hex_color.dart';
import 'package:smart/features/recipes/widgets/recipe_story_overlay.dart';
import 'package:video_player/video_player.dart';

class RecipeStoryScreen extends StatefulWidget {
  RecipeStoryScreen({this.duration, this.image, this.title, this.text, this.textColor});

  final String image;
  final String title;
  final String text;
  final int duration;
  final String textColor;

  @override
  State<RecipeStoryScreen> createState() => _RecipeStoryScreenState();
}

class _RecipeStoryScreenState extends State<RecipeStoryScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (lookupMimeType(widget.image) != 'image/png' || lookupMimeType(widget.image) != 'image/jpeg') {
      // _controller = VideoPlayerController.network(
      //   widget.image,
      //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      // );
      Uri videoUri = Uri.parse(widget.image);
      _controller = VideoPlayerController.networkUrl(
        videoUri,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _controller.addListener(() async => setState(() {}));
      _controller.setLooping(true);
      _controller.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return lookupMimeType(widget.image) == 'image/png' || lookupMimeType(widget.image) == 'image/jpeg'
        ? Stack(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Image.network(widget.image, alignment: Alignment.center, fit: BoxFit.cover),
              ),
              Positioned(
                top: heightRatio(size: 126, context: context),
                left: widthRatio(size: 32, context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: appLabelTextStyle(
                            color: HexColor(widget.textColor),
                            fontSize: heightRatio(size: 20, context: context),
                          ),
                        ),
                        SizedBox(width: widthRatio(size: 9.0, context: context)),
                        // widget.duration != null && widget.duration > 0
                        //     ? Container(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: 3.8, horizontal: 5.0),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(16.0),
                        //       color: Colors.white),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       SvgPicture.asset(
                        //           'assets/images/timer_for_recipes.svg'),
                        //       SizedBox(
                        //           width: widthRatio(
                        //               size: 4.0, context: context)),
                        //       Text('${widget.duration.toString()} мин'),
                        //     ],
                        //   ),
                        // )
                        //     : SizedBox(),
                      ],
                    ),
                    Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: appHeadersTextStyle(color: HexColor(widget.textColor), fontSize: 33.0, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20.0,
                right: 20.0,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    width: widthRatio(size: 28.0, context: context),
                    height: heightRatio(size: 28.0, context: context),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                    child: SvgPicture.asset(
                      'assets/images/exit_from_slides_button.svg',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : _controller.value.isInitialized
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          RecipeStoryOverlay(controller: _controller),
                          VideoProgressIndicator(_controller, allowScrubbing: true),
                          Positioned(
                            top: 10.0,
                            right: 20.0,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                width: widthRatio(size: 28.0, context: context),
                                height: heightRatio(size: 28.0, context: context),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                                child: SvgPicture.asset(
                                  'assets/images/exit_from_slides_button.svg',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: widthRatio(size: width, context: context),
                height: heightRatio(size: height - 160.0, context: context),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
              );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
