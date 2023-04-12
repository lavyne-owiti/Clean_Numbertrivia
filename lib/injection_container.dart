import 'dart:developer';

import 'package:cleanarchi/core/network/network_info.dart';
import 'package:cleanarchi/core/util/input_convertor.dart';
import 'package:cleanarchi/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanarchi/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleanarchi/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleanarchi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanarchi/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:cleanarchi/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:cleanarchi/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// service locator
final sl = GetIt.instance;

Future<void> init() async {
  try {
    // ! features = number trivia
    // bloc
    sl.registerFactory(() => NumberTriviaBloc(
          getConcreteNumberTrivia: sl(),
          getRandomNumberTrivia: sl(),
          inputConvertor: sl(),
        ));

    // use cases
    sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
    sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

    // repository
    sl.registerLazySingleton<NumberTriviaRepositoy>(
        () => NumberTriviaRepositoryImpl(
              remoteDataSource: sl(),
              localDatasource: sl(),
              networkInfo: sl(),
            ));

    // datasource
    sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => NumberTriviaRemoteDataSourceImpl(
              client: sl(),
            ));
    sl.registerLazySingleton<NumberTriviaLocalDataSource>(
        () => NumberTriviaLocalDataSourceImpl(
              sharedPreferences: sl(),
            ));

    // ! core
    sl.registerLazySingleton(() => InputConvertor());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    //! External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => http.Client());
    sl.registerLazySingleton(() => DataConnectionChecker());
  } catch (error, stack) {
    log(
      "error is $error",
    );
    log(
      "$stack"
    );
  }
}
