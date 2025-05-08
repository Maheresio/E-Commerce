import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/home/presentation/controller/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/app_strings.dart';
import 'home_banner.dart';
import 'list_view_header.dart';
import 'list_view_item.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeBanner(),
          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(spacing: 20, children: [SaleSection(), NewSection()]),
          ),
        ],
      ),
    );
  }
}

class SaleSection extends StatelessWidget {
  const SaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListViewHeader(
          title: AppStrings.kSale,
          subtitle: AppStrings.kSuperSummerSale,
          onPressed: () {},
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: Consumer(
            builder: (context, ref, child) {
              return ref
                  .watch(saleProductsProvider)
                  .when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            AppStrings.kNoProductsFound,
                            style: AppStyles.font18PrimarySemiBold,
                          ),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => ListViewItem(data[index]),
                        separatorBuilder: (_, index) => SizedBox(width: 16),
                        itemCount: data.length,
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(
                          error is Failure ? error.message : error.toString(),

                          style: AppStyles.font16BlackRegular,
                        ),
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                  );
            },
          ),
        ),
      ],
    );
  }
}

class NewSection extends StatelessWidget {
  const NewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListViewHeader(
          title: AppStrings.kNew,
          subtitle: AppStrings.kNeverSeenBefore,
          onPressed: () {},
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: Consumer(
            builder: (context, ref, child) {
              return ref
                  .watch(newProductsProvider)
                  .when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            AppStrings.kNoProductsFound,
                            style: AppStyles.font18PrimarySemiBold,
                          ),
                        );
                      }
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => ListViewItem(data[index]),
                        separatorBuilder: (_, index) => SizedBox(width: 16),
                        itemCount: data.length,
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(
                        child: Text(
                          error is Failure ? error.message : error.toString(),
                          style: AppStyles.font16BlackRegular,
                        ),
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                  );
            },
          ),
        ),
      ],
    );
  }
}
