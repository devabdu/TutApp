import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final ForgotPasswordViewModel _forgotPasswordViewModel =
      instance<ForgotPasswordViewModel>();

  final TextEditingController _emilTextEditingController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _bind() {
    _forgotPasswordViewModel.start();
    _emilTextEditingController.addListener(() =>
        _forgotPasswordViewModel.setEmail(_emilTextEditingController.text));
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
        stream: _forgotPasswordViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _forgotPasswordViewModel.forgotPassword();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.only(top: AppPadding.p100),
      color: ColorManager.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               const Image(
                image: AssetImage(ImagesAssets.splashLogo),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p26, right: AppPadding.p26),
                child: StreamBuilder<bool>(
                  stream: _forgotPasswordViewModel.outputIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emilTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint.tr(),
                          labelText: AppStrings.emailHint.tr(),
                          errorText: (snapshot.data ?? true)
                              ? null
                              : AppStrings.invalidEmail.tr()),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p26, right: AppPadding.p26),
                child: StreamBuilder<bool>(
                  stream: _forgotPasswordViewModel.outputIsInputValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () => _forgotPasswordViewModel.forgotPassword()
                              : null,
                          child:  Text(AppStrings.resetPassword.tr())),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
