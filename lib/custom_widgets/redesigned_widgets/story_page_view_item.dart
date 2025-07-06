import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/core/constants/source.dart';

import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/models/stories_list_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryPageViewItem extends StatefulWidget {
  final StoriesListDataModel storiesListDataModel;
  final void Function() onComplete;
  const StoryPageViewItem(this.storiesListDataModel, this.onComplete);

  @override
  State<StoryPageViewItem> createState() => _StoryPageViewItemState();
}

class _StoryPageViewItemState extends State<StoryPageViewItem> {
  final controller = StoryController();
  List<StoryItem> storyItems;
  int currentIndex = 0;
  bool isTimerMove = false;
  Color textColor = blackColor;

  setSharedStoriesList({@required String sotryId}) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    List<String> storiesList = await _shared.getStringList('storiesList') ?? [];
    if (storiesList.contains(sotryId) != true) {
      storiesList.add(sotryId);
      await _shared.setStringList("storiesList", storiesList);
    }
  }

  @override
  void initState() {
    setSharedStoriesList(sotryId: widget.storiesListDataModel.id.toString());
    isTimerMove = false;
    controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.pause:
          break;
        case PlaybackState.next:
          if (currentIndex < widget.storiesListDataModel.tabs.length - 1) {
            currentIndex++;
          }
          isTimerMove = false;
          break;
        case PlaybackState.previous:
          if (currentIndex > 0) {
            currentIndex--;
          }
          isTimerMove = false;

          break;
        case PlaybackState.play:
          break;

        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    storyItems = widget.storiesListDataModel.tabs
        .map((e) => StoryItem(
            Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: e.logoFilePath != null
                        ? Image.network(
                            e.logoFilePath,
                            fit: BoxFit.cover,
                            height: screenHeight(context),
                            width: screenWidth(context),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                isTimerMove = true;
                              } else {
                                isTimerMove = false;
                              }
                              return loadingProgress == null
                                  ? child
                                  : Container(
                                      color: colorBlack03,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                                      ),
                                    );
                            },
                          )
                        : SizedBox()),
                Positioned(
                    right: widthRatio(size: 24, context: context),
                    left: widthRatio(size: 24, context: context),
                    top: heightRatio(size: 124, context: context),
                    child: SafeArea(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title ?? "",
                          style: appTextStyle(color: e.textColor == null || e.textColor.isEmpty ? blackColor : Color(int.parse("0xff${e.textColor.replaceAll("#", "")}")), fontSize: heightRatio(size: 36, context: context), fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: heightRatio(size: 16, context: context),
                        ),
                        Text(
                          e.text ?? "",
                          style: appTextStyle(fontSize: heightRatio(size: 22, context: context), color: e.textColor == null ? blackColor : Color(int.parse("0xff${e.textColor.replaceAll("#", "")}")), fontWeight: FontWeight.w500),
                        ),
                      ],
                    )))
              ],
            ),
            duration: Duration(seconds: e.duration.toInt())))
        .toList();
    return Stack(
      children: [
        //Tabs List Builder
        StoryView(
            inline: true,
            onStoryShow: (value) {
              if (isTimerMove) {
                if (currentIndex < widget.storiesListDataModel.tabs.length - 1) {
                  currentIndex++;
                }
              } else {
                isTimerMove = true;
              }
            },
            onComplete: () {
              widget.onComplete.call();
              isTimerMove = false;
            },
            storyItems: storyItems,
            controller: controller,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down || direction == Direction.up) {
                Navigator.pop(context);
              }
            }),
        Positioned(
            right: widthRatio(size: 16, context: context),
            top: heightRatio(size: 20, context: context),
            child: SafeArea(
              bottom: false,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset("assets/images/close_button_for_story.svg"),
                ),
              ),
            )),
        widget.storiesListDataModel.tabs.length > 0 && widget.storiesListDataModel.tabs[currentIndex].url != null
            ? Positioned(
                left: widthRatio(size: 16, context: context),
                right: widthRatio(size: 16, context: context),
                bottom: heightRatio(size: 40, context: context),
                child: InkWell(
                  onTap: () {
                    print(currentIndex + 1);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(widthRatio(size: 12, context: context)), color: whiteColor),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: heightRatio(size: 16, context: context)),
                    child: Text(tr("moreText")),
                  ),
                ))
            : SizedBox(),
      ],
    );
  }
}
