import 'package:firebase_auth/firebase_auth.dart';

Future<String> getCurrentUserId() async => FirebaseAuth.instance.currentUser!.uid;
