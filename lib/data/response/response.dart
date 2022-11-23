import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "status")
  int? status;
  @JsonKey(name: "message")
  String? message;
}

@JsonSerializable()
class UserResponse {
  @JsonKey(name: "id")
  String? userId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "numOfNotifications")
  int? userNumOfNotification;

  UserResponse(this.userId, this.name, this.userNumOfNotification);

  // from Json
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  // to Json
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class ContactsResponse {
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "link")
  String? link;

  ContactsResponse(this.phone, this.email, this.link);

  // from Json
  factory ContactsResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactsResponseFromJson(json);

  // to Json
  Map<String, dynamic> toJson() => _$ContactsResponseToJson(this);
}

@JsonSerializable()
class AuthenticationResponse extends BaseResponse {
  @JsonKey(name: "user")
  UserResponse? user;
  @JsonKey(name: "contacts")
  ContactsResponse? contacts;

  AuthenticationResponse(this.user, this.contacts);

  // from Json
  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  // to Json
  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class ForgotPasswordResponse extends BaseResponse {
  @JsonKey(name: "support")
  String? support;

  ForgotPasswordResponse(this.support);

  // from Json
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);

  // to Json
  Map<String, dynamic> toJson() => _$ForgotPasswordResponseToJson(this);
}

@JsonSerializable()
class ServiceResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "image")
  String? image;

  ServiceResponse(this.id, this.title, this.image);

  // from Json
  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}

@JsonSerializable()
class BannerResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "link")
  String? link;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "image")
  String? image;

  BannerResponse(this.id, this.link, this.title, this.image);

  // from Json
  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class StoreResponse {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "image")
  String? image;

  StoreResponse(this.id, this.title, this.image);

  // from Json
  factory StoreResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$StoreResponseToJson(this);
}

@JsonSerializable()
class HomeDataResponse {
  @JsonKey(name: "services")
  List<ServiceResponse>? services;
  @JsonKey(name: "banners")
  List<BannerResponse>? banners;
  @JsonKey(name: "stores")
  List<StoreResponse>? stores;

  HomeDataResponse(this.services, this.banners, this.stores);

  // from Json
  factory HomeDataResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDataResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$HomeDataResponseToJson(this);
}

@JsonSerializable()
class HomeResponse extends BaseResponse {
  @JsonKey(name: "data")
  HomeDataResponse? data;

  HomeResponse(this.data);

  // from Json
  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

@JsonSerializable()
class StoreDetailsResponse extends BaseResponse {
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "details")
  String? details;
  @JsonKey(name: "services")
  String? services;
  @JsonKey(name: "about")
  String? about;

  StoreDetailsResponse(
      this.image, this.id, this.title, this.details, this.services, this.about);

  // from Json
  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreDetailsResponseFromJson(json);

  // to json
  Map<String, dynamic> toJson() => _$StoreDetailsResponseToJson(this);
}
