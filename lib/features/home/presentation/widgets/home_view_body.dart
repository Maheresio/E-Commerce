import 'package:flutter/material.dart';

import 'home_banner.dart';
import 'home_new_section.dart';
import 'home_sale_section.dart';

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
              children: [HomeSaleSection(), HomeNewSection()],
            ),
          ),
        ],
      ),
    );
  }
}
