import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmissionProtectionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  bool get isSubmitting => state;

  Future<T> protectSubmission<T>(Future<T> Function() submission) async {
    if (state) {
      throw Exception('Submission already in progress');
    }

    state = true;
    try {
      final result = await submission();
      return result;
    } finally {
      state = false;
    }
  }

  void reset() {
    state = false;
  }
}

final submissionProtectionProvider =
    NotifierProvider<SubmissionProtectionNotifier, bool>(
      SubmissionProtectionNotifier.new,
    );
