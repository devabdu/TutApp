import 'dart:async';
import 'dart:ffi';
import 'package:rxdart/rxdart.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/domain/usecase/home_usecase.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);



  final StreamController _homeDataStreamController =
  BehaviorSubject<HomeViewObject>();

  //inputs
  @override
  void start() {
    _getHomeData();
  }

  @override
  void dispose() {
    _homeDataStreamController.close();
    super.dispose();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullscreenLoadingState));
    (await _homeUseCase.execute(Void)).fold(
          (failure) {
        inputState.add(ErrorState(
            StateRendererType.fullscreenErrorState, failure.messageFailure));
      },
          (homeObject) {
        inputState.add(ContentState());
        inputsHomeData.add(HomeViewObject(homeObject.data.services, homeObject.data.stores, homeObject.data.banners));
      },
    );
  }

  @override
  Sink get inputsHomeData => _homeDataStreamController.sink;

  //outputs
  @override
  Stream<HomeViewObject> get outputsHomeData =>
      _homeDataStreamController.stream.map((data) => data);

}
abstract class HomeViewModelInputs {
  Sink get inputsHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputsHomeData;
}

class HomeViewObject {
  List<Services> services;
  List<Stores> stores;
  List<Banners> banners;

  HomeViewObject(this.services, this.stores, this.banners);
}
