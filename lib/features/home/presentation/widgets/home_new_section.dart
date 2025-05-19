import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../controller/home_provider.dart';
import 'home_list_view_header.dart';
import 'home_list_view_item.dart';

class HomeNewSection extends StatelessWidget {
  const HomeNewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeListViewHeader(
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
                        itemBuilder:
                            (_, index) => HomeListViewItem(data[index]),
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
