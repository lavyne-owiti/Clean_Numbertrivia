import 'dart:convert';
import 'package:cleanarchi/core/error/exceptions.dart';
import 'package:cleanarchi/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleanarchi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Mock implements Uri {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late FakeUri fakeUri = FakeUri();

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(fakeUri);
  });

  void setUpHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response("something went wrong", 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should preform a GET request on URL with number 
    being the endpoint and with application/json header''', () async {
      // arrange
      setUpHttpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });
    test('should  return NumberTrivia when the response code is 200(success)',
        () async {
      // arrange
      setUpHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return a ServerException when the return code is 404 or other',
        () async {
      // arrange
      setUpHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should preform a GET request on URL with number 
    being the endpoint and with application/json header''', () async {
      // arrange
      setUpHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });
    test('should  return NumberTrivia when the response code is 200(success)',
        () async {
      // arrange
      setUpHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return a ServerException when the return code is 404 or other',
        () async {
      // arrange
      setUpHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia();
      // assert
      expect(
          () => call, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
