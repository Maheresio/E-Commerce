import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firestore_sevice.dart';

final Provider<FirestoreServices> firestoreServicesProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices.instance);
