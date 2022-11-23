import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/presentation/common/state_renderer/state_randerer_impl.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';
import 'package:tut_app/presentation/store_details/viewmodel/store_details_viewmodel.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _storeDetailsViewModel =
      instance<StoreDetailsViewModel>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _storeDetailsViewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _storeDetailsViewModel.outputState,
          builder: (context, snapshot) {
            return Container(
              child: snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _storeDetailsViewModel.start();
                  }) ??
                  Container(),
            );
          }),
    );
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title:  Text(AppStrings.storeDetails.tr()),
        elevation: AppSize.s0,
        iconTheme: const IconThemeData(
          color: ColorManager.white,
        ),
        backgroundColor: ColorManager.primary,
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: ColorManager.white,
        child: SingleChildScrollView(
          child: StreamBuilder<StoreDetails>(
              stream: _storeDetailsViewModel.outputsStoreDetails,
              builder: (context, snapshot) {
                return _getItems(snapshot.data);
              }),
        ),
      ),
    );
  }

  Widget _getItems(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Image.network(
            storeDetails.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          )),
          _getSection(AppStrings.detailsSection.tr()),
          _getInfoText(storeDetails.details),
          _getSection(AppStrings.servicesSection.tr()),
          _getInfoText(storeDetails.services),
          _getSection(AppStrings.aboutSection.tr()),
          _getInfoText(storeDetails.about)
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String sectionName) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p12,
      ),
      child: Text(
        sectionName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _getInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.s12),
      child: Text(info, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  @override
  void dispose() {
    _storeDetailsViewModel.dispose();
    super.dispose();
  }
}
