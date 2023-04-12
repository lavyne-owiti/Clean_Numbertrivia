import 'package:cleanarchi/core/util/input_convertor.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConvertor inputConvertor;

  setUp(() {
    inputConvertor = InputConvertor();
  });

  group('StringToUnsignedInt', () {
    test(
        'should return interger when the string represents an unsigned integer ',
        () async {
            // arrange
            const str = '123';
            // act
            final result = inputConvertor.stringToUnsignedInterger(str);
            // assert
            expect(result, const Right(123));
    });

    test(
            'should return a Failure when the string is not an integer ',
            () async {
                // arrange
                const str = 'abc';
                // act
                final result = inputConvertor.stringToUnsignedInterger(str);
                // assert
                expect(result,  Left(InvalidInputFailure()));
    });

    test(
            'should return a Failure when the string is a negative integer ',
            () async {
                // arrange
                const str = '-123';
                // act
                final result = inputConvertor.stringToUnsignedInterger(str);
                // assert
                expect(result,  Left(InvalidInputFailure()));
          }); 


  });
}
