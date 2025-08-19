import 'package:e_commerce/features/checkout/presentation/widgets/styled_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../common/presentation/views/see_all_view.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../providers/search_provider.dart';

class SearchResultView extends ConsumerStatefulWidget {
  const SearchResultView({super.key});

  @override
  ConsumerState<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends ConsumerState<SearchResultView> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ProductEntity>> searchState = ref.watch(
      searchProvider,
    );

    return searchState.when(
      data: (List<ProductEntity> products) {
        if (products.isEmpty) {
          return const _EmptySearchState();
        }
        return SeeAllView.searchResults(products);
      },
      loading: () {
        return const SearchResultLoading();
      },
      error: (Object error, StackTrace stackTrace) {
        return _SearchErrorState(error: error.toString());
      },
    );
  }
}

class SearchResultsByTags extends ConsumerWidget {
  const SearchResultsByTags({super.key, required this.searchTags});
  final List<String> searchTags;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      SeeAllView.searchByTags(ref, searchTags);
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppStrings.kUploadAnImageToSimilarProducts,
            style: AppStyles.font34BlackBold(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _SearchErrorState extends StatelessWidget {
  const _SearchErrorState({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            AppStrings.kSomethingWentWrong,
            style: AppStyles.font34BlackBold(context),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppStyles.font48BlackBold(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class SearchResultLoading extends StatelessWidget {
  const SearchResultLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar(context, title: AppStrings.kFindingResults),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(AppImages.searchLottie),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                textAlign: TextAlign.center,
                AppStrings.kFindingResults,
                style: AppStyles.font34BlackBold(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
