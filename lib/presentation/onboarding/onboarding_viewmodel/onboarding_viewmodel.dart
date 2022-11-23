import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  final StreamController _streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentPageIndex = 0;

  @override
  void start() {
    _list = _getSliderObject();
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  int swipeRight() {
    int nextIndex = ++_currentPageIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int swipeLeft() {
    int previousIndex = --_currentPageIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentPageIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  List<SliderObject> _getSliderObject() => [
        SliderObject(AppStrings.onBoardingTitle1.tr(),
            AppStrings.onBoardingSubTitle1.tr(), ImagesAssets.onBoardingLogo1),
        SliderObject(AppStrings.onBoardingTitle2.tr(),
            AppStrings.onBoardingSubTitle2.tr(), ImagesAssets.onBoardingLogo2),
        SliderObject(AppStrings.onBoardingTitle3.tr(),
            AppStrings.onBoardingSubTitle3.tr(), ImagesAssets.onBoardingLogo3),
        SliderObject(AppStrings.onBoardingTitle4.tr(),
            AppStrings.onBoardingSubTitle4.tr(), ImagesAssets.onBoardingLogo4),
      ];

  void _postDataToView() {
    inputSliderViewObject.add(
      SliderViewObject(
        _list[_currentPageIndex],
        _list.length,
        _currentPageIndex,
      ),
    );
  }
}

abstract class OnBoardingViewModelInputs {
  int swipeRight();

  int swipeLeft();

  void onPageChanged(int index);

  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}
