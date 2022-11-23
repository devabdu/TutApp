import 'dart:async';
import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/domain/usecase/store_details_usecase.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  final StreamController _storeDetailsStreamController =
      BehaviorSubject<StoreDetails>();

  // inputs
  @override
  void start() {
    _getStoreDetails();
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
  }

  @override
  Sink get inputsStoreDetails => _storeDetailsStreamController.sink;

  _getStoreDetails() async{
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullscreenLoadingState));
    (await _storeDetailsUseCase.execute(Void)).fold(
          (failure) {
        inputState.add(ErrorState(
            StateRendererType.fullscreenErrorState, failure.messageFailure));
      },
          (storeDetails) {
        inputState.add(ContentState());
        inputsStoreDetails.add(storeDetails);
      },
    );
  }

  //outputs
  @override
  Stream<StoreDetails> get outputsStoreDetails =>
      _storeDetailsStreamController.stream.map((storeDetail) => storeDetail);
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputsStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputsStoreDetails;
}
