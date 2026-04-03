import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Нет сети или таймаут']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Требуется авторизация']);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Неизвестная ошибка']);
}
