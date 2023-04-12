import 'package:bloc/bloc.dart';
import 'package:cleanarchi/core/error/failure.dart';
import 'package:cleanarchi/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/util/input_convertor.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecase/get_concrete_number_trivia.dart';
import '../../domain/usecase/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input = The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConvertor inputConvertor;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConvertor})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        emit(Empty());
        final inputEither =
            inputConvertor.stringToUnsignedInterger(event.numberString);

        inputEither.fold(
          (failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Empty());
        emit(Loading());
            final failureOrTrivia =
                await getRandomNumberTrivia(NoParams());
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
      }
    });
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit, 
  Either<Faliure, NumberTrivia> failureOrTrivia) async {
     emit(failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    ));
  }
  
  String _mapFailureToMessage(Faliure faliure) {
    switch (faliure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
