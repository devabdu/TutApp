import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/presentation/onboarding/onboarding_viewmodel/onboarding_viewmodel.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/constants_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _onBoardingViewModel = OnBoardingViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _appPreferences.setOnBoardingScreenViewed();
    _onBoardingViewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _onBoardingViewModel.outputSliderViewObject,
        builder: (context, snapshot) {
          return _getContentWidget(snapshot.data);
        });
  }

  Widget _getContentWidget([SliderViewObject? sliderViewObject]) {
    if (sliderViewObject != null) {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
        ),
        body: PageView.builder(
          itemCount: sliderViewObject.numOfSlides,
          controller: _pageController,
          onPageChanged: (index) {
            _onBoardingViewModel.onPageChanged(index);
          },
          itemBuilder: (context, index) {
            return OnBoardingPage(sliderViewObject.sliderObject);
          },
        ),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(
                    AppStrings.skip.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              _getBottomSheetWidget(sliderViewObject),
            ],
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    _onBoardingViewModel.swipeLeft(),
                    duration: const Duration(
                      milliseconds: AppConstants.sliderAnimationTime,
                    ),
                    curve: Curves.bounceInOut,
                  );
                },
                child: SizedBox(
                  height: AppSize.s20,
                  width: AppSize.s20,
                  child: SvgPicture.asset(ImagesAssets.leftArrowIcon),
                ),
              ),
            ),
            Row(
              children: [
                for (int i = 0; i < sliderViewObject.numOfSlides; i++)
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    child: _getProperCircle(i, sliderViewObject.currentIndex),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    _onBoardingViewModel.swipeRight(),
                    duration: const Duration(
                      milliseconds: AppConstants.sliderAnimationTime,
                    ),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                child: SizedBox(
                  height: AppSize.s20,
                  width: AppSize.s20,
                  child: SvgPicture.asset(ImagesAssets.rightArrowIcon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImagesAssets.hollowCircle);
    } else {
      return SvgPicture.asset(ImagesAssets.solidCircle);
    }
  }

  @override
  void dispose() {
    _onBoardingViewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSize.s40,
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: AppSize.s60,
        ),
        SvgPicture.asset(
          _sliderObject.image,
        ),
      ],
    );
  }
}
