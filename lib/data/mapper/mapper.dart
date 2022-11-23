import 'package:tut_app/app/constants.dart';
import 'package:tut_app/data/response/response.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/app/extension.dart';

extension UserResponseMapper on UserResponse? {
  User toDomain() {
    return User(
        this?.userId.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.userNumOfNotification.orZero() ?? Constants.zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
        this?.phone.orEmpty() ?? Constants.empty,
        this?.email.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(this?.user.toDomain(), this?.contacts.toDomain());
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomain() {
    return this?.support?.orEmpty() ?? Constants.empty;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Services toDomain() {
    return Services(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension BannerResponseMapper on BannerResponse? {
  Banners toDomain() {
    return Banners(
        this?.id.orZero() ?? Constants.zero,
        this?.link.orEmpty() ?? Constants.empty,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Stores toDomain() {
    return Stores(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Services> services = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Services>()
        .toList();

    List<Banners> banners = (this
                ?.data
                ?.banners
                ?.map((bannerResponse) => bannerResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Banners>()
        .toList();

    List<Stores> stores = (this
                ?.data
                ?.stores
                ?.map((storesResponse) => storesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Stores>()
        .toList();

    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
      this?.image.orEmpty() ?? Constants.empty,
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.details.orEmpty() ?? Constants.empty,
      this?.services.orEmpty() ?? Constants.empty,
      this?.about.orEmpty() ?? Constants.empty,
    );
  }
}
