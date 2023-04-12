import 'package:cleanarchi/core/error/failure.dart';
import 'package:cleanarchi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepositoy {
  Future<Either<Faliure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Faliure, NumberTrivia>> getRandomNumberTrivia();
}
