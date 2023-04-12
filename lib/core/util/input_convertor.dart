import 'package:cleanarchi/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConvertor {
  Either<Faliure, int> stringToUnsignedInterger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Faliure {}
