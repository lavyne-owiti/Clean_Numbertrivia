import 'package:cleanarchi/core/error/failure.dart';
import 'package:cleanarchi/core/usecases/usecase.dart';
import 'package:cleanarchi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepositoy repositoy;

  GetConcreteNumberTrivia(this.repositoy);

  @override
  Future<Either<Faliure, NumberTrivia>> call(
    Params params,
  ) async {
    return await repositoy.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object?> get props => ([number]);
}
