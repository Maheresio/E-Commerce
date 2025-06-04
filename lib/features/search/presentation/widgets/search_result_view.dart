import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/core/utils/app_images.dart';
import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../providers/search_provider.dart';

class SearchResultView extends ConsumerStatefulWidget {
  const SearchResultView({super.key});

  @override
  ConsumerState<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends ConsumerState<SearchResultView> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(searchProvider);
    return Scaffold(
      body: provider.when(
        data:
            (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                return Text(products[index], style: AppStyles.font48BlackBold);
              },
            ),
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Something went wrong $error',
              style: AppStyles.font34BlackBold,
            ),
          );
        },
        loading: () => const SearchResultLoading(),
      ),
    );
  }
}

class SearchResultLoading extends StatelessWidget {
  const SearchResultLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(AppImages.searchLottie),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            textAlign: TextAlign.center,
            AppStrings.kFindingResults,
            style: AppStyles.font34BlackBold,
          ),
        ),
      ],
    );
  }
}
