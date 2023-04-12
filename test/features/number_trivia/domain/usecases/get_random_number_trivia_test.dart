import 'package:cleanarchi/core/usecases/usecase.dart';
import 'package:cleanarchi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleanarchi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanarchi/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepositoy {}

late GetRandomNumberTrivia usecase;
late MockNumberTriviaRepository mockNumberTriviaRepository;

Future<void> main() async {
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test("should get trivia from the repository", () async {
    // arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
