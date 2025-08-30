import 'package:flutter/material.dart';

import 'styled_loading.dart';

class StyledModalBarrier extends StatelessWidget {
  const StyledModalBarrier({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.black.withValues(alpha: 0.5),
    child: const Center(child: StyledLoading()),
  );
}
