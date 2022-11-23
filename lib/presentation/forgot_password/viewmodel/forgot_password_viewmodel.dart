import 'dart:async';

import 'package:tut_app/app/functions.dart';
import 'package:tut_app/domain/usecase/forgot_password_usecase.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isInputValidStreamController =
      StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  var email = "";

  //inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsInputValid => _isInputValidStreamController.sink;

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold(
        (failure) => {
              inputState.add(ErrorState(
                  StateRendererType.popupErrorState, failure.messageFailure))
            },
        (supportMessage) => {
              inputState.add(SuccessState(StateRendererType.popupSuccessState, supportMessage))
            });
  }

  // outputs
  @override
  void dispose() {
    _emailStreamController.close();
    _isInputValidStreamController.close();
  }

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsInputValid => _isInputValidStreamController.stream
      .map((isInputValid) => _isInputValid());

  _isInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsInputValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInputs {
  forgotPassword();

  setEmail(String email);

  Sink get inputEmail;

  Sink get inputIsInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsInputValid;
}
