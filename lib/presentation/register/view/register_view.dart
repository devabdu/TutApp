import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/app/constants.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _registerViewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  _bind() {
    _registerViewModel.start();
    _userNameTextEditingController.addListener(() {
      _registerViewModel.setUserName(_userNameTextEditingController.text);
    });
    _mobileNumberTextEditingController.addListener(() {
      _registerViewModel
          .setMobileNumber(_mobileNumberTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _registerViewModel.setEmail(_emailTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _registerViewModel.setPassword(_passwordTextEditingController.text);
    });
    _registerViewModel.isUserRegisteredInSuccessfullyStreamController.stream
        .listen((isRegisteredIn) {
      if (isRegisteredIn) {
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
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: const IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _registerViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _registerViewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
        padding: const EdgeInsets.only(top: AppPadding.p10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Center(
                    child: Image(image: AssetImage(ImagesAssets.splashLogo))),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p26,
                  ),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorUserName,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _userNameTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.userName.tr(),
                              labelText: AppStrings.userName.tr(),
                              errorText: snapshot.data),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p26,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CountryCodePicker(
                              onChanged: (country) {
                                _registerViewModel.setCountryCode(
                                    country.dialCode ?? Constants.apiToken);
                              },
                              initialSelection: '+20',
                              favorite: const ['+39', 'FR', "+966"],
                              // optional. Shows only country name and flag
                              showCountryOnly: true,
                              hideMainText: true,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: true,
                            )),
                        Expanded(
                            flex: 4,
                            child: StreamBuilder<String?>(
                                stream:
                                    _registerViewModel.outputErrorMobileNumber,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller:
                                        _mobileNumberTextEditingController,
                                    decoration: InputDecoration(
                                        hintText: AppStrings.mobileNumber.tr(),
                                        labelText: AppStrings.mobileNumber.tr(),
                                        errorText: snapshot.data),
                                  );
                                })),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p26,
                  ),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorEmail,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.emailHint.tr(),
                              labelText: AppStrings.emailHint.tr(),
                              errorText: snapshot.data),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p26,
                  ),
                  child: StreamBuilder<String?>(
                      stream: _registerViewModel.outputErrorPassword,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextEditingController,
                          decoration: InputDecoration(
                            hintText: AppStrings.password.tr(),
                            labelText: AppStrings.password.tr(),
                            errorText: snapshot.data,
                            errorMaxLines: 2,
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p26,
                  ),
                  child: Container(
                    height: AppSize.s40,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppSize.s8)),
                        border: Border.all(color: ColorManager.grey)),
                    child: GestureDetector(
                      child: _getMediaWidget(),
                      onTap: () {
                        _showPicker(context);
                      },
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
                      stream: _registerViewModel.outputIsAreAllInputsValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _registerViewModel.register();
                                    }
                                  : null,
                              child:  Text(AppStrings.register.tr())),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppPadding.p8,
                      left: AppPadding.p26,
                      right: AppPadding.p26),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.alreadyHaveAccount.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Flexible(child: Text(AppStrings.profilePicture.tr())),
          Flexible(
              child: StreamBuilder<File>(
            stream: _registerViewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePickerByUse(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImagesAssets.profileCameraIcon)),
        ],
      ),
    );
  }

  Widget _imagePickerByUse(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: const Icon(Icons.arrow_forward),
                  leading: const Icon(Icons.photo_library),
                  title:  Text(AppStrings.imageFromGallery.tr()),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: const Icon(Icons.arrow_forward),
                  leading: const Icon(Icons.camera_alt),
                  title:  Text(AppStrings.imageFromCamera.tr()),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  @override
  void dispose() {
    _registerViewModel.dispose();
    super.dispose();
  }
}
