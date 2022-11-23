import 'package:tut_app/data/network/app_api.dart';
import 'package:tut_app/data/network/requests.dart';
import 'package:tut_app/data/response/response.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequests loginRequests);

  Future<AuthenticationResponse> register(RegisterRequests registerRequests);

  Future<ForgotPasswordResponse> forgotPassword(String email);

  Future<HomeResponse> getHomeData();
  Future<StoreDetailsResponse> getStoreDetails();
}

class RemoteDataSourceImplementation implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImplementation(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequests loginRequests) async {
    return await _appServiceClient.login(
        loginRequests.email, loginRequests.password);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email) async {
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<AuthenticationResponse> register(
      RegisterRequests registerRequests) async {
    return await _appServiceClient.register(
        registerRequests.userName,
        registerRequests.countryMobileCode,
        registerRequests.mobileNumber,
        registerRequests.email,
        registerRequests.password,
        "",
        // registerRequests.profilePicture
        );
  }

  @override
  Future<HomeResponse> getHomeData() async{
    return await _appServiceClient.getHomeData();
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async{
    return await _appServiceClient.getStoreDetails();
  }
}
