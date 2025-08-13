import '../helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class StyledModalBarrier extends StatelessWidget {
  const StyledModalBarrier({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(context.color.primary),
        ),
      ),
    );
}
