import 'package:cleanarchi/core/error/failure.dart';
import 'package:cleanarchi/core/usecases/usecase.dart';
import 'package:cleanarchi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepositoy repositoy;

  GetRandomNumberTrivia(this.repositoy);

  @override
  Future<Either<Faliure, NumberTrivia>> call(NoParams params) async {
    return await repositoy.getRandomNumberTrivia();
  }
}


