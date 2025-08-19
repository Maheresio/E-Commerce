import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/server_failure.dart';
import '../../../home/data/models/product_model.dart';
import '../datasources/search_remote_data_source.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remote);
  final SearchRemoteDataSource _remote;

  @override
  Future<Either<Failure, String>> uploadImage(
    Uint8List bytes, {
    String? fileName,
  }) async {
    final String filePathInBucket =
        fileName ?? '${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      final publicUrl = await _remote.uploadImage(bytes, filePathInBucket);
      return Right(publicUrl);
    } on StorageException catch (e) {
      return Left(Failure('Storage error: ${e.message}'));
    } on SocketException {
      return const Left(Failure('No internet connection.'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTags(String imageUrl) async {
    try {
      final List<String> tags = await _remote.getClothesTags(imageUrl);
      return Right(tags);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProductsByTags(
    List<String> tags, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async {
    try {
      final List<ProductModel> products = await _remote.searchProductsByTags(
        tags,
        lastDocument: lastDocument,
        pageSize: pageSize,
      );
      return Right(products);
    } on FirebaseException catch (e) {
      return Left(Failure('Database error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String filePathInBucket) async {
    try {
      await _remote.deleteImage(filePathInBucket);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(Failure('Storage error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllImages() async {
    try {
      await _remote.clearAllImages();
      return const Right(null);
    } on StorageException catch (e) {
      return Left(Failure('Storage error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
