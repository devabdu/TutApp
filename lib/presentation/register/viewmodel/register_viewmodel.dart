import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:tut_app/app/functions.dart';
import 'package:tut_app/domain/usecase/register_usecase.dart';
import 'package:tut_app/presentation/base/base_viewmodel.dart';
import 'package:tut_app/presentation/common/freezed.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();
  var registerObject = RegisterObject("", "", "", "", "", "");

  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  // inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputsEmail => _emailStreamController.sink;

  @override
  Sink get inputsMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputsPassword => _passwordStreamController.sink;

  @override
  Sink get inputsProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputsUserName => _userNameStreamController.sink;

  @override
  Sink get inputsAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setUserName(String userName) {
    inputsUserName.add(userName);
    if (_isUserNameValid(userName)) {
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      registerObject = registerObject.copyWith(userName: "");
    }
    _validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputsMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    _validate();
  }

  @override
  setEmail(String email) {
    inputsEmail.add(email);
    if (isEmailValid(email)) {
      registerObject = registerObject.copyWith(email: email);
    } else {
      registerObject = registerObject.copyWith(email: "");
    }
    _validate();
  }

  @override
  setPassword(String password) {
    inputsPassword.add(password);
    if (isPasswordValid(password)) {
      registerObject = registerObject.copyWith(password: password);
    } else {
      registerObject = registerObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputsProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    _validate();
  }

  @override
  register() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.popupLoadingState),
    );
    (await _registerUseCase.execute(RegisterUseCaseInput(
      registerObject.userName,
      registerObject.countryMobileCode,
      registerObject.mobileNumber,
      registerObject.email,
      registerObject.password,
      registerObject.profilePicture,
    )))
        .fold(
            (failure) => inputState.add(ErrorState(
                StateRendererType.popupErrorState, failure.messageFailure)),
            (data) => {
                  inputState.add(SuccessState(
                    StateRendererType.popupSuccessState,
                    AppStrings.registeredSuccessfully.tr(),
                  )),
                  inputState.add(ContentState()),
                  isUserRegisteredInSuccessfullyStreamController.add(true),
                });
  }

  // outputs
  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outputIsUserNameValid.map(
      (isUserName) => isUserName ? null : AppStrings.userNameRegisterError.tr());

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumber) =>
          isMobileNumber ? null : AppStrings.mobileNumberRegisterError.tr());

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmail) => isEmail ? null : AppStrings.emailRegisterError.tr());

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPassword) => isPassword ? null : AppStrings.passwordRegisterError.tr());

  @override
  Stream<File> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputIsAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  // private_functions
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length == 11;
  }

  bool _areAllInputsValid() {
    return registerObject.userName.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  _validate() {
    inputsAreAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInputs {
  Sink get inputsUserName;

  Sink get inputsMobileNumber;

  Sink get inputsEmail;

  Sink get inputsPassword;

  Sink get inputsProfilePicture;

  Sink get inputsAreAllInputsValid;

  register();

  setUserName(String userName);

  setCountryCode(String countryCode);

  setMobileNumber(String mobileNumber);

  setEmail(String email);

  setPassword(String password);

  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;

  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;

  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;

  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;

  Stream<String?> get outputErrorPassword;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputIsAreAllInputsValid; //

}
