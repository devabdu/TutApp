import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/data/network/requests.dart';
import 'package:dartz/dartz.dart';
import 'package:tut_app/domain/model/models.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequests loginRequests);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, Authentication>> register(
      RegisterRequests registerRequests);

  Future<Either<Failure, HomeObject>> getHomeData();

  Future<Either<Failure, StoreDetails>> getStoreDetails();
}
