// File: storage_repository_impl.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/features/search/data/datasources/search_remote_data_source.dart';
import 'package:e_commerce/features/search/domain/repositories/search_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/server_failure.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remote;

  SearchRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, String>> uploadImage(Uint8List bytes) async {
    try {
      final String publicUrl = await _remote.uploadImage(
        bytes,
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
      return Right(publicUrl);
    } on StorageException catch (e) {
      return Left(Failure('Storage error: ${e.message}'));
    } on SocketException {
      return Left(Failure('No internet connection.'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTags(String imageUrl) async {
    try {
      return Right(await _remote.getClothesTags(imageUrl));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }
}
