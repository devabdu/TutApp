import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/font_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/style_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

enum StateRendererType {
  // POPUP STATES
  popupLoadingState,
  popupErrorState,
  popupSuccessState,

  // FULL SCREEN STATED
  fullscreenLoadingState,
  fullscreenErrorState,
  fullscreenEmptyState,

  // GENERAL
  contentState
}

class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  String stateRenderMessage;
  String stateRenderTitle;
  Function retryActionFunction;

  StateRenderer({
    required this.stateRendererType,
    this.stateRenderMessage = AppStrings.loading,
    this.stateRenderTitle = "",
    required this.retryActionFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getStateWidget(context),
    );
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog(context, [_getAnimatedImage( animationStateImage: JsonAssets.loadingState)]);
      case StateRendererType.popupErrorState:
        return _getPopupDialog(context, [
          _getAnimatedImage(animationStateImage: JsonAssets.errorState),
          _getMessage(stateRenderMessage),
          _getRetryButton(AppStrings.popupErrorTextButton.tr(), context),
        ]);
      case StateRendererType.popupSuccessState:
        return _getPopupDialog(context, [
          _getAnimatedImage(animationStateImage: JsonAssets.successState),
          _getMessage(stateRenderTitle),
          _getMessage(stateRenderMessage),
          _getRetryButton(AppStrings.popupSuccessTextButton.tr(), context),
        ]);
      case StateRendererType.fullscreenLoadingState:
        return _getItemColumn([
          _getAnimatedImage(animationStateImage: JsonAssets.loadingState),
          _getMessage(stateRenderMessage),
        ]);
      case StateRendererType.fullscreenErrorState:
        return _getItemColumn([
          _getAnimatedImage(animationStateImage: JsonAssets.errorState),
          _getMessage(stateRenderMessage),
          _getRetryButton(AppStrings.fullscreenErrorTextButton.tr(), context),
        ]);
      case StateRendererType.fullscreenEmptyState:
        return _getItemColumn([
          _getAnimatedImage(animationStateImage: JsonAssets.emptyState),
          _getMessage(stateRenderMessage),
        ]);
      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: ColorManager.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [
            BoxShadow(
              color: ColorManager.black_26,
            )
          ],
        ),
        child: _getDialogColumn(context, children),
      ),
    );
  }

  Widget _getDialogColumn(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  // Full Screen Renderer
  Widget _getItemColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  // common widgets
  Widget _getAnimatedImage({required String animationStateImage}) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationStateImage),
    );
  }
  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _getRetryButton(String textButton, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p26,
          vertical: AppPadding.p8,
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (stateRendererType == StateRendererType.fullscreenErrorState) {
                retryActionFunction.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(textButton),
          ),
        ),
      ),
    );
  }
}
