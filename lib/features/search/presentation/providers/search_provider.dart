import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../../home/data/models/product_model.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_products_by_tags.dart';
import '../../domain/usecases/get_clothes_tags_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';
import '../../domain/usecases/delete_image_usecase.dart';
import '../../domain/usecases/clear_all_images_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/service_locator.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../shop/presentation/controller/pagination_async_notifier.dart';
import '../../data/datasources/search_remote_data_source.dart';

class SearchNotifier extends AsyncNotifier<List<ProductEntity>> {
  Future<void> processImage(Uint8List bytes) async {
    state = const AsyncLoading();

    // Generate unique filename for tracking
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    // Step 1: Upload image
    final UploadImageUsecase uploadImageUsecase = ref.read(
      uploadImageUsecaseProvider,
    );
    final Either<Failure, String> uploadResult = await uploadImageUsecase
        .execute(bytes, fileName: fileName);

    final String? url = uploadResult.fold((Failure failure) {
      state = AsyncError(failure.message, StackTrace.current);
      return null;
    }, (String result) => result);

    if (url == null) return;

    // Step 2: Extract tags from image
    final GetClothesTagsUsecase getClothesTagsUsecase = ref.read(
      getClothesTagsUsecaseProvider,
    );
    final Either<Failure, List<String>> tagsResult = await getClothesTagsUsecase
        .execute(url);

    final List<String>? tags = tagsResult.fold((Failure failure) {
      state = AsyncError(failure.message, StackTrace.current);
      _clearAllImages();
      return null;
    }, (List<String> result) => result);

    if (tags == null || tags.isEmpty) {
      state = AsyncError('No tags found in image', StackTrace.current);
      await _clearAllImages();
      return;
    }

    // Step 3: Search products by tags

    final SearchProductsByTagsUseCase searchUseCase = ref.read(
      searchProductsByTagsUsecaseProvider,
    );
    final Either<Failure, List<ProductModel>> productsResult =
        await searchUseCase.execute(tags);

    productsResult.fold(
      (Failure failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (List<ProductModel> products) {
        final List<ProductEntity> productEntities =
            products.cast<ProductEntity>();
        state = AsyncData(productEntities);
        _clearAllImages(); // Cleanup after successful search
      },
    );
  }

  // Helper method to clear all uploaded images from bucket
  Future<void> _clearAllImages() async {
    final ClearAllImagesUsecase clearAllImagesUsecase = ref.read(
      clearAllImagesUsecaseProvider,
    );

    await clearAllImagesUsecase.execute();
  }

  @override
  FutureOr<List<ProductEntity>> build() {
    return <ProductEntity>[];
  }
}

final Provider<SearchRemoteDataSource> searchRemoteDataSourceProvider =
    Provider<SearchRemoteDataSource>(
      (_) => SearchRemoteDataSourceImpl(
        storageService: sl<SupabaseStorageService>(),
        dioClient: sl<DioClient>(),
        firestore: sl<FirestoreServices>(),
      ),
    );
final Provider<SearchRepository> searchRepositoryProvider =
    Provider<SearchRepository>(
      (ref) => SearchRepositoryImpl(ref.read(searchRemoteDataSourceProvider)),
    );
final Provider<UploadImageUsecase> uploadImageUsecaseProvider =
    Provider<UploadImageUsecase>(
      (ref) => UploadImageUsecase(ref.read(searchRepositoryProvider)),
    );
final Provider<GetClothesTagsUsecase> getClothesTagsUsecaseProvider =
    Provider<GetClothesTagsUsecase>(
      (ref) => GetClothesTagsUsecase(ref.read(searchRepositoryProvider)),
    );

final Provider<DeleteImageUsecase> deleteImageUsecaseProvider =
    Provider<DeleteImageUsecase>(
      (ref) => DeleteImageUsecase(ref.read(searchRepositoryProvider)),
    );

final Provider<ClearAllImagesUsecase> clearAllImagesUsecaseProvider =
    Provider<ClearAllImagesUsecase>(
      (ref) => ClearAllImagesUsecase(ref.read(searchRepositoryProvider)),
    );

final Provider<SearchProductsByTagsUseCase>
searchProductsByTagsUsecaseProvider = Provider<SearchProductsByTagsUseCase>(
  (ref) => SearchProductsByTagsUseCase(ref.read(searchRepositoryProvider)),
);

final searchProvider =
    AsyncNotifierProvider<SearchNotifier, List<ProductEntity>>(
      () => SearchNotifier(),
    );

// Additional provider to get just the extracted tags if needed
class TagsNotifier extends AsyncNotifier<List<String>> {
  Future<void> extractTagsFromImage(Uint8List bytes) async {
    state = const AsyncLoading();

    // Step 1: Upload image
    final UploadImageUsecase uploadImageUsecase = ref.read(
      uploadImageUsecaseProvider,
    );
    final Either<Failure, String> uploadResult = await uploadImageUsecase
        .execute(bytes);

    final String? url = uploadResult.fold((Failure failure) {
      state = AsyncError(failure.message, StackTrace.current);
      return null;
    }, (String result) => result);

    if (url == null) return;

    // Step 2: Extract tags from image
    final GetClothesTagsUsecase getClothesTagsUsecase = ref.read(
      getClothesTagsUsecaseProvider,
    );
    final Either<Failure, List<String>> tagsResult = await getClothesTagsUsecase
        .execute(url);

    tagsResult.fold(
      (Failure failure) {
        state = AsyncError(failure.message, StackTrace.current);
      },
      (List<String> result) {
        state = AsyncData(result);
      },
    );
  }

  @override
  FutureOr<List<String>> build() {
    return <String>[];
  }
}

final tagsProvider = AsyncNotifierProvider<TagsNotifier, List<String>>(
  () => TagsNotifier(),
);

// Search fetch function
FetchFunction getSearchByTagsFetch(WidgetRef ref, List<String> tags) => ({
  DocumentSnapshot? lastDocument,
  int pageSize = 10,
}) async {
  try {
    final useCase = ref.read(searchProductsByTagsUsecaseProvider);
    final result = await useCase.execute(
      tags,
      lastDocument: lastDocument,
      pageSize: pageSize,
    );

    return result.fold((failure) => Left(failure), (products) {
      // ProductModel extends ProductEntity, so we can cast directly
      final entities = products.cast<ProductEntity>();

      return Right(entities);
    });
  } catch (e) {
    return Left(Failure(e.toString()));
  }
};

// Search pagination provider
final AsyncNotifierProviderFamily<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>
searchPaginationProvider = AsyncNotifierProvider.family<
  PaginationAsyncNotifier,
  List<ProductEntity>,
  FetchFunction
>(PaginationAsyncNotifier.new);
