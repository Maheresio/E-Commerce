import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/services/firestore_sevice.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import 'package:e_commerce/features/search/domain/usecases/get_clothes_tags_usecase.dart';
import 'package:e_commerce/features/search/domain/usecases/upload_image_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/service_locator.dart';
import '../../data/datasources/search_remote_data_source.dart';

class SearchNotifier extends AsyncNotifier<List<String>> {
  Future<void> processImage(Uint8List bytes) async {
    state = const AsyncLoading();

    late final String url;
    final uploadImageUsecase = ref.read(uploadImageUsecaseProvider);
    final uploadResult = await uploadImageUsecase.execute(bytes);
    uploadResult.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (result) {
        url = result;
      },
    );

    late final List<String> tags;
    final getClothesTagsUsecase = ref.read(getClothesTagsUsecaseProvider);
    final tagsResult = await getClothesTagsUsecase.execute(url);
    tagsResult.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (result) {
        tags = result;
        state = AsyncData(tags);
      },
    );

    // Get products from Firestore based on tags
    // final productsResult = await _searchProducts(tags);
    // productsResult.fold(
    //   (failure) => state = AsyncError(failure.message, StackTrace.current),
    //   (products) => state = AsyncData(products),
    // );
  }

  @override
  FutureOr<List<String>> build() => [];
}

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((_) {
  return SearchRemoteDataSourceImpl(
    storageService: sl<SupabaseStorageService>(),
    dioClient: sl<DioClient>(),
    firestore: sl<FirestoreServices>(),
  );
});
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.read(searchRemoteDataSourceProvider));
});
final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  return UploadImageUsecase(ref.read(searchRepositoryProvider));
});
final getClothesTagsUsecaseProvider = Provider<GetClothesTagsUsecase>((ref) {
  return GetClothesTagsUsecase(ref.read(searchRepositoryProvider));
});

final searchProvider = AsyncNotifierProvider<SearchNotifier, List<String>>(() {
  return SearchNotifier();
});
