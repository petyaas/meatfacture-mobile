import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/bloc_files/stories_list_bloc.dart';
import 'package:smart/main.dart';
import 'package:smart/models/stories_list_model.dart';
import 'package:smart/pages/redesigned_pages/story_page.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/core/constants/text_styles.dart';

class StoriesListWidget extends StatefulWidget {
  @override
  State<StoriesListWidget> createState() => _StoriesListWidgetState();
}

class _StoriesListWidgetState extends State<StoriesListWidget> {
  StoriesListModel storiesListModel;
  List<String> storiesList;

  setSharedStoriesList({@required String sotryId}) async {
    if (storiesList.contains(sotryId) != true) {
      setState(() {
        storiesList.add(sotryId);
      });
      await prefs.setStringList("storiesList", storiesList);
    }
  }

  void loadStoriesList() async {
    setState(() {
      storiesList = prefs.getStringList('storiesList') ?? [];
    });
  }

  @override
  void initState() {
    setState(() {
      loadStoriesList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // loadStoriesList();
    return BlocBuilder<StoriesListBloc, StoriesListState>(
      builder: (context, state) {
        if (state is StoriesListLoadedState) {
          storiesListModel = state.storiesListModel;
        }

        // if (state is StoriesListLoadingState) {
        //   return Container(
        //     alignment: Alignment.center,
        //     height: heightRatio(size: 82, context: context),
        //     child: CircularProgressIndicator(),
        //   );
        // }

        if (storiesListModel == null || storiesListModel.data.isEmpty) {
          return SizedBox();
        } else {
          return SizedBox(
            height: heightRatio(size: 118, context: context),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: widthRatio(size: 6, context: context)),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: storiesListModel.data.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  //set storeis as checked
                  setSharedStoriesList(sotryId: storiesListModel.data[index].id.toString());
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                    builder: (context) => StoryPage(storiesListModel: storiesListModel, initStory: index),
                  ))
                      .then((value) {
                    loadStoriesList();
                    setState(() {});
                  });
                },
                child: storiesListItemWidget(storiesItem: storiesListModel.data[index], context: context, storiesList: storiesList),
              ),
            ),
          );
        }
      },
    );
  }
}

storiesListItemWidget({@required StoriesListDataModel storiesItem, @required BuildContext context, @required List<String> storiesList}) {
  return Stack(
    children: [
      Container(
        height: heightRatio(size: 90, context: context),
        margin: EdgeInsets.only(right: widthRatio(size: 4, context: context)),
        padding: EdgeInsets.all(widthRatio(size: 2, context: context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widthRatio(size: 24, context: context)),
          border: Border.all(
              width: widthRatio(size: 2, context: context),
              color: storiesList != null
                  ? storiesList.contains(storiesItem.id.toString())
                      ? Colors.transparent
                      : mainColor
                  : Colors.transparent),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widthRatio(size: 82, context: context),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(widthRatio(size: 22, context: context))),
          child: Image.network(
            storiesItem.logoFilePath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return loadingProgress == null ? child : Container(height: heightRatio(size: 82, context: context), width: widthRatio(size: 82, context: context), color: colorBlack03);
            },
          ),
        ),
      ),
      Positioned(
        bottom: heightRatio(size: 0, context: context),
        left: widthRatio(size: 4, context: context),
        right: widthRatio(size: 7, context: context),
        child: Container(
          height: heightRatio(size: 24, context: context),
          child: Text(
            storiesItem.name ?? '',
            style: appLabelTextStyle(fontSize: heightRatio(size: 12, context: context), color: Colors.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ],
  );
}
