import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart/core/constants/source.dart';
import 'package:smart/features/home/banners/banner_item.dart';
import 'package:smart/features/home/banners/bloc/banners_bloc.dart';
import 'package:smart/features/home/banners/bloc/banners_state.dart';

class Banners extends StatelessWidget {
  const Banners();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersBloc, BannersState>(
      builder: (context, state) {
        if (state is BannersLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[100],
            highlightColor: Colors.white,
            child: Container(
              height: heightRatio(size: 165, context: context),
              decoration: BoxDecoration(
                color: newIconBg,
                borderRadius: BorderRadius.all(
                  Radius.circular(widthRatio(size: 12, context: context)),
                ),
              ),
            ),
          );
        } else if (state is BannersError) {
          return Center(child: Text("Ошибка: ${state.message}"));
        } else if (state is BannersLoaded && state.banners.data.isNotEmpty) {
          final slides = state.banners.data;
          return ClipRRect(
            borderRadius: BorderRadius.circular(heightRatio(size: 12, context: context)),
            child: SizedBox(
              height: heightRatio(size: 165, context: context),
              child: slides.length > 1
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              height: heightRatio(size: 165, context: context),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              autoPlayAnimationDuration: const Duration(milliseconds: 500),
                              autoPlayInterval: const Duration(seconds: 5),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                // Обновлять слайдер можно в StatefulWidget
                              },
                            ),
                            items: slides.map(
                              (i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return BannerItem(bannersListDataModel: i);
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - widthRatio(size: 40, context: context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                slides.length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 12,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : BannerItem(bannersListDataModel: slides[0]),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
