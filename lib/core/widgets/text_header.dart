import '../services/firestore_sevice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/firestore_constants.dart';
import '../utils/app_styles.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () async {
        final path = FirestoreConstants.userCart(
          FirebaseAuth.instance.currentUser!.uid,
        );
        await FirestoreServices.instance.deleteCollection(path: path);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(title, style: AppStyles.font34BlackBold(context)),
      ),
    );
}
