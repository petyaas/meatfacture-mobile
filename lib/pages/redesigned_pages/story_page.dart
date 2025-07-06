import 'package:flutter/material.dart';
import 'package:smart/models/stories_list_model.dart';

import '../../custom_widgets/redesigned_widgets/story_page_view_item.dart';

// ignore: must_be_immutable
class StoryPage extends StatefulWidget {
  StoriesListModel storiesListModel;
  int initStory;
  StoryPage({this.initStory, this.storiesListModel});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initStory);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      children: [
        ...widget.storiesListModel.data
            .map((e) => StoryPageViewItem(
                  e,
                  () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                ))
            .toList()
      ],
    ));
  }
}
