import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _homeViewModel = instance<HomeViewModel>();

  _bind() {
    _homeViewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
            stream: _homeViewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _homeViewModel.start();
                  }) ??
                  _getContentWidget();
            }),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<HomeViewObject>(
      stream: _homeViewModel.outputsHomeData,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getBannerWidget(snapshot.data?.banners),
            _getSection(AppStrings.servicesTitle.tr()),
            _getServicesWidget(snapshot.data?.services),
            _getSection(AppStrings.storesTitle.tr()),
            _getStoresWidget(snapshot.data?.stores),
          ],
        );
      }
    );
  }

  Widget _getBannerWidget(List<Banners>? banners) {
    if (banners != null) {
      return CarouselSlider(
          items: banners
              .map((banner) => SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: AppSize.s1_5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        side: const BorderSide(
                            color: ColorManager.primary, width: AppSize.s1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        child: Image.network(
                          banner.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              height: AppSize.s190,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeCenterPage: true));
    } else {
      return Container();
    }
  }

  Widget _getServicesWidget(List<Services>? services) {
    if (services != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
        child: Container(
          height: AppSize.s160,
          margin: const EdgeInsets.symmetric(vertical: AppMargin.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map(
                  (service) => Card(
                    elevation: AppSize.s4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      side: const BorderSide(
                          color: ColorManager.white, width: AppSize.s1),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          child: Image.network(
                            service.image,
                            fit: BoxFit.cover,
                            width: AppSize.s120,
                            height: AppSize.s120,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppSize.s8),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                service.title,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getStoresWidget(List<Stores>? stores) {
    if (stores != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GridView.count(
              crossAxisCount: AppCounts.c2,
              crossAxisSpacing: AppSize.s8,
              mainAxisSpacing: AppSize.s8,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                stores.length,
                (index) => InkWell(
                  child: Card(
                    elevation: AppSize.s4,
                    child: Image.network(
                      stores[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String typeSection) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p12, vertical: AppPadding.p8/2),
      child: Text(
        typeSection,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }
}
