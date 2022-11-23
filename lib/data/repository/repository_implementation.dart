import 'package:dartz/dartz.dart';
import 'package:tut_app/data/data_source/local_data_source.dart';
import 'package:tut_app/data/data_source/remote_data_source.dart';
import 'package:tut_app/data/mapper/mapper.dart';
import 'package:tut_app/data/network/error_handler.dart';
import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/data/network/network_info.dart';
import 'package:tut_app/data/network/requests.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/domain/repository/repository.dart';

class RepositoryImplementation implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImplementation(this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequests loginRequests) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(loginRequests);
        if (response.status == ApiInternalStatus.success) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.forgotPassword(email);
        if (response.status == ApiInternalStatus.success) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequests registerRequests) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.register(registerRequests);
        if (response.status == ApiInternalStatus.success) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(ApiInternalStatus.failure,
              response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        print(error);
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.success) {
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            return Left(Failure(ApiInternalStatus.failure,
                response.message ?? ResponseMessage.unKnown));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async{
    try {
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.getStoreDetails();
          if (response.status == ApiInternalStatus.success) {
            _localDataSource.saveStoreDetailsToCache(response);
            return Right(response.toDomain());
          } else {
            return Left(Failure(ApiInternalStatus.failure,
                response.message ?? ResponseMessage.unKnown));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
}
