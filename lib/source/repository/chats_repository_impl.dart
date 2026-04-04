import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/error/failures.dart';
import 'package:project_temp/source/models/chat_models/chat_detail.dart';
import 'package:project_temp/source/models/chat_models/chat_message_response.dart';
import 'package:project_temp/source/models/chat_models/chat_summary.dart';
import 'package:project_temp/source/repository/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  ChatsRepositoryImpl({required DioClient dioClient}) : _dio = dioClient;

  final DioClient _dio;

  @override
  Future<Either<Failure, List<ChatSummary>>> listChats() async {
    try {
      final response = await _dio.authenticatedDio.get<dynamic>(
        ApiEndpoints.chats,
      );
      final data = response.data;
      if (data is! List) {
        return const Left(ServerFailure('Ожидался список чатов'));
      }
      final list = data
          .whereType<Map>()
          .map((e) => ChatSummary.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Right(list);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, ChatDetail>> getChat(int chatId) async {
    try {
      final response = await _dio.authenticatedDio.get<Map<String, dynamic>>(
        ApiEndpoints.chatPath(chatId),
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(ChatDetail.fromJson(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, ChatMessageResponse>> createChat(
    String question,
  ) async {
    try {
      final response = await _dio.authenticatedDio.post<Map<String, dynamic>>(
        ApiEndpoints.chats,
        data: {'question': question},
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(ChatMessageResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  @override
  Future<Either<Failure, ChatMessageResponse>> sendMessage(
    int chatId,
    String question,
  ) async {
    try {
      final response =
          await _dio.authenticatedDio.post<Map<String, dynamic>>(
        ApiEndpoints.chatMessagesPath(chatId),
        data: {'question': question},
      );
      final data = response.data;
      if (data == null) {
        return const Left(ServerFailure('Пустой ответ сервера'));
      }
      return Right(ChatMessageResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } on FormatException catch (e) {
      return Left(ValidationFailure(e.message));
    } on Object catch (e) {
      return Left(ExceptionToFailure.map(e));
    }
  }

  Failure _mapDio(DioException e) {
    final inner = e.error;
    if (inner is AppException) {
      return ExceptionToFailure.map(inner);
    }
    return ExceptionToFailure.map(DioExceptionMapper.map(e));
  }
}
