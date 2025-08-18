import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/firestore_failure.dart';
import '../../../../core/error/socket_failure.dart';

import '../../../../core/error/handle_repository_exceptions.dart';
import '../models/product_model.dart';
import '../../domain/repositories/home_repository.dart';

import '../../../../core/error/server_failure.dart';
import '../datasources/home_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {

  HomeRepositoryImpl(this.homeDataSource);
  final HomeDataSource homeDataSource;

  @override
  Stream<List<ProductModel>> newProducts() async* {
    try {
      yield* homeDataSource.newProducts();
    } on FirebaseException catch (e) {
      yield* Stream.error(
        FirestoreFailure.fromCode(e.message ?? 'Firebase error'),
      );
    } on SocketException {
      yield* Stream.error(SocketFailure.fromCode('No internet connection'));
    } on FormatException {
      yield* Stream.error(const ServerFailure('Data format error'));
    } catch (e) {
      yield* Stream.error(Failure('Unexpected error: $e'));
    }
  }

  @override
  Stream<List<ProductModel>> saleProducts() async* {
    try {
      yield* homeDataSource.saleProducts();
    } on FirebaseException catch (e) {
      yield* Stream.error(
        FirestoreFailure.fromCode(e.message ?? 'Firebase error'),
      );
    } on SocketException {
      yield* Stream.error(SocketFailure.fromCode('No internet connection'));
    } on FormatException {
      yield* Stream.error(const ServerFailure('Data format error'));
    } catch (e) {
      yield* Stream.error(Failure('Unexpected error: $e'));
    }
  }

  @override
  Future<void> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await homeDataSource.updateProduct(id: id, data: data);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromCode(e.message ?? 'Firebase error');
    } on SocketException {
      throw SocketFailure.fromCode('No internet connection');
    } on FormatException {
      throw const ServerFailure('Data format error');
    } catch (e) {
      throw Failure('Unexpected error: $e');
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String productId) async => handleRepositoryExceptions(() async {
      final result = await homeDataSource.getProductById(productId);
      return result;
    });
}
