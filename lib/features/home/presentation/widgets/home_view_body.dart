import 'package:flutter/material.dart';

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
            child: Column(
              spacing: 20,
              children: [SaleSection(), SaleSection()],
            ),
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
        ListViewHeader(),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 16,
            children: [
              ...List.generate(8, (index) {
                return ListViewItem();
              }),
            ],
          ),
        ),
      ],
    );
  }
}
