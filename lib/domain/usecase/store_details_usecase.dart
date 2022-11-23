import 'package:dartz/dartz.dart';
import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/domain/repository/repository.dart';
import 'package:tut_app/domain/usecase/base_usecase.dart';

class StoreDetailsUseCase implements BaseUseCase <void, StoreDetails> {
  final Repository _repository;
  StoreDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async{
    return await _repository.getStoreDetails();
  }
}