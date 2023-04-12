import 'dart:convert';
import 'package:cleanarchi/core/error/exceptions.dart';
import 'package:cleanarchi/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanarchi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });
  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));
    test(
        "should return NumberTrivia from the SharedPreferences when there is one inthe cache",
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture("trivia_cached.json"));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw cacheException when there is not cached", () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert
      expect(() async => await call(),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group("cacheNumberTrivia", () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test("should call SharedPreferences to cache the data", () async {
      // when
      when(() => mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, any()))
          .thenAnswer((_) async => true);
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA,
            expectedJsonString,
          ));
    });
  });
}
