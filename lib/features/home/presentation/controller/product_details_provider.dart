import '../../../../core/utils/app_strings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSelection extends Equatable {
  const ProductSelection({required this.size, required this.color});
  final String size;
  final String color;

  @override
  List<Object?> get props => <Object?>[size, color];
}

class ProductSelectionNotifier extends StateNotifier<ProductSelection> {
  ProductSelectionNotifier(super.state);

  void updateSize(String newSize) {
    state = ProductSelection(size: newSize, color: state.color);
  }

  void updateColor(String newColor) {
    state = ProductSelection(size: state.size, color: newColor);
  }

  void reset() {
    state = const ProductSelection(
      size: AppStrings.kSize,
      color: AppStrings.kColor,
    );
  }
}

final AutoDisposeStateNotifierProvider<
  ProductSelectionNotifier,
  ProductSelection
>
productSelectionProvider = StateNotifierProvider.autoDispose<
  ProductSelectionNotifier,
  ProductSelection
>(
  (ref) => ProductSelectionNotifier(
    const ProductSelection(size: AppStrings.kSize, color: AppStrings.kColor),
  ),
);
