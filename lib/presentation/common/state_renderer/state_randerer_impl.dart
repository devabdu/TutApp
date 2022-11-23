import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/app/constants.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getStateRenderMessage();
}

// loading state (POPUP, FULL SCREEN)
class LoadingState extends FlowState {
  final StateRendererType stateRendererType;
  String? messageState;

  LoadingState(
      {required this.stateRendererType,
      this.messageState =  AppStrings.loading});

  @override
  String getStateRenderMessage() => messageState ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state (POPUP, FULL SCREEN)
class ErrorState extends FlowState {
  final StateRendererType stateRendererType;
  String messageState;

  ErrorState(this.stateRendererType, this.messageState);

  @override
  String getStateRenderMessage() => messageState;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// success state(POPUP)
class SuccessState extends FlowState {
  final StateRendererType stateRendererType;
  String messageState;

  SuccessState(this.stateRendererType, this.messageState);

  @override
  String getStateRenderMessage() => messageState;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// empty state
class EmptyState extends FlowState {
  String messageState;

  EmptyState(this.messageState);

  @override
  String getStateRenderMessage() => messageState;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullscreenEmptyState;
}

// content state
class ContentState extends FlowState {
  ContentState();

  @override
  String getStateRenderMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            showPopup(context, getStateRendererType(), getStateRenderMessage(), stateRenderTitle: AppStrings.success.tr());
            return contentScreenWidget;
          } else {
            return StateRenderer(
                stateRenderMessage: getStateRenderMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            showPopup(context, getStateRendererType(), getStateRenderMessage(), stateRenderTitle: AppStrings.error.tr());
            return contentScreenWidget;
          } else {
            return StateRenderer(
                stateRenderMessage: getStateRenderMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case SuccessState:
        {
          dismissDialog(context);
          showPopup(context, getStateRendererType(), getStateRenderMessage(),stateRenderTitle: AppStrings.success.tr());
          return contentScreenWidget;
        }
      case EmptyState:
        return StateRenderer(
            stateRendererType: getStateRendererType(),
            stateRenderMessage: getStateRenderMessage(),
            retryActionFunction: () {});
      case ContentState:
        dismissDialog(context);
        return contentScreenWidget;
      default:
        dismissDialog(context);
        return contentScreenWidget;
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
    BuildContext context,
    StateRendererType stateRendererType,
    String stateRenderMessage,
      {String stateRenderTitle = Constants.empty}
  ) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          stateRenderTitle: stateRenderTitle,
          stateRenderMessage: stateRenderMessage,
          retryActionFunction: () {},
        ),
      ),
    );
  }
}
