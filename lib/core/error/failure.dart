import 'package:equatable/equatable.dart';

abstract class Faliure extends Equatable {
  final List properties;
  const Faliure([this.properties = const []]) : super();

  @override
  List<Object?> get props => [properties];
}

// general failures
class ServerFailure extends Faliure {
  
}

class CacheFailure extends Faliure {}