import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/notifier.dart';

import '../../../../core/services/firestore_sevice.dart';

final Provider<FirestoreServices> firestoreServicesProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices.instance);

class BooleanNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
  void setValue(bool value) => state = value;
}

final isGridViewModeProvider = NotifierProvider<BooleanNotifier, bool>(
  BooleanNotifier.new,
);
