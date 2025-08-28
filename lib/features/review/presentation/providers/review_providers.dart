import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../data/datasources/review_remote_data_source.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../../domain/usecases/delete_review_use_case.dart';
import '../../domain/usecases/get_product_reviews_use_case.dart';
import '../../domain/usecases/get_user_review_for_product_use_case.dart';
import '../../domain/usecases/mark_review_helpful_use_case.dart';
import '../../domain/usecases/update_review_use_case.dart';

// FirestoreServices Provider
final Provider<FirestoreServices> firestoreServicesProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices.instance);

// Data Source Provider
final Provider<ReviewRemoteDataSource> reviewRemoteDataSourceProvider =
    Provider<ReviewRemoteDataSource>(
      (ref) => ReviewRemoteDataSourceImpl(
        firestoreServices: ref.read(firestoreServicesProvider),
      ),
    );

// Repository Provider
final Provider<ReviewRepository> reviewRepositoryProvider =
    Provider<ReviewRepository>(
      (ref) => ReviewRepositoryImpl(
        remoteDataSource: ref.read(reviewRemoteDataSourceProvider),
      ),
    );

// Use Case Providers
final Provider<GetProductReviewsUseCase> getProductReviewsUseCaseProvider =
    Provider<GetProductReviewsUseCase>(
      (ref) => GetProductReviewsUseCase(ref.read(reviewRepositoryProvider)),
    );

final Provider<GetUserReviewForProductUseCase>
getUserReviewForProductUseCaseProvider = Provider<
  GetUserReviewForProductUseCase
>((ref) => GetUserReviewForProductUseCase(ref.read(reviewRepositoryProvider)));

final Provider<AddReviewUseCase> addReviewUseCaseProvider =
    Provider<AddReviewUseCase>(
      (ref) => AddReviewUseCase(ref.read(reviewRepositoryProvider)),
    );

final Provider<UpdateReviewUseCase> updateReviewUseCaseProvider =
    Provider<UpdateReviewUseCase>(
      (ref) => UpdateReviewUseCase(ref.read(reviewRepositoryProvider)),
    );

final Provider<DeleteReviewUseCase> deleteReviewUseCaseProvider =
    Provider<DeleteReviewUseCase>(
      (ref) => DeleteReviewUseCase(ref.read(reviewRepositoryProvider)),
    );

final Provider<MarkReviewHelpfulUseCase> markReviewHelpfulUseCaseProvider =
    Provider<MarkReviewHelpfulUseCase>(
      (ref) => MarkReviewHelpfulUseCase(ref.read(reviewRepositoryProvider)),
    );
