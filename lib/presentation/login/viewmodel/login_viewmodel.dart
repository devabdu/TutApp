import 'dart:async';

import 'package:tut_app/domain/usecase/login_usecase.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/common/freezed.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();

  var loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputsUserName => _userNameStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputsAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputsAreAllInputsValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputsUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputsAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
      (failure) {
        inputState.add(ErrorState(StateRendererType.popupErrorState, failure.messageFailure));
      },
      (data) {
        inputState.add(ContentState());
        isUserLoggedInSuccessfullyStreamController.add(true);
      },
    );
  }

  // outputs
  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameCorrect(userName));

  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordCorrect(password));

  @override
  Stream<bool> get outputsAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isUserNameCorrect(String userName) => userName.isNotEmpty;

  bool _isPasswordCorrect(String password) => password.isNotEmpty;

  bool _areAllInputsValid() =>
      _isPasswordCorrect(loginObject.password) &&
      _isUserNameCorrect(loginObject.userName);
}

abstract class LoginViewModelInputs {
  setUserName(String userName);

  setPassword(String password);

  login();

  Sink get inputsUserName;

  Sink get inputPassword;

  Sink get inputsAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;

  Stream<bool> get outIsPasswordValid;

  Stream<bool> get outputsAreAllInputsValid;
}
