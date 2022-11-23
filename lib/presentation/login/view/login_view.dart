import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _loginViewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _loginViewModel.start();
    _userNameController.addListener(
        () => _loginViewModel.setUserName(_userNameController.text));
    _userPasswordController.addListener(
        () => _loginViewModel.setPassword(_userPasswordController.text));
    _loginViewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setIsUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);

        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _loginViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _loginViewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      color: ColorManager.white,
      padding: const EdgeInsets.only(top: AppPadding.p100),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage(ImagesAssets.splashLogo),
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p26,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outIsUserNameValid,
                  builder: (context, snapshot) => TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: AppStrings.userName.tr(),
                      labelText: AppStrings.userName.tr(),
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.usernameError.tr(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p26,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outIsPasswordValid,
                  builder: (context, snapshot) => TextFormField(
                    controller: _userPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: AppStrings.password.tr(),
                      labelText: AppStrings.password.tr(),
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.passwordError.tr(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p26,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outputsAreAllInputsValid,
                  builder: (context, snapshot) => SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                      onPressed: (snapshot.data ?? false)
                          ? () {
                              _loginViewModel.login();
                            }
                          : null,
                      child:  Text(AppStrings.login.tr()),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  right: AppPadding.p26,
                  left: AppPadding.p26,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, Routes.forgotPasswordRoute),
                      child: Text(
                        AppStrings.forgotPassword.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, Routes.registerRoute),
                      child: Text(
                        AppStrings.singUp.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }
}
