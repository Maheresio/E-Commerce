import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this.dataSource);
  final CartDataSource dataSource;

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart(String userId) async =>
      handleRepositoryExceptions(() async {
        return await dataSource.getCartItems(userId);
      });

  @override
  Future<Either<Failure, void>> addOrUpdate(
    String userId,
    CartItemEntity item,
  ) async => handleRepositoryExceptions(() async {
    final model = CartItemModel(
      id: item.id,
      productId: item.productId,
      quantity: item.quantity,
      selectedSize: item.selectedSize,
      selectedColor: item.selectedColor,
      imageUrl: item.imageUrl,
      name: item.name,
      price: item.price,
      brand: item.brand,
    );
    await dataSource.addOrUpdateItem(userId, model);
  });

  @override
  Future<Either<Failure, void>> remove(String userId, String itemId) async =>
      handleRepositoryExceptions(() async {
        await dataSource.removeItem(userId, itemId);
      });

  @override
  Future<Either<Failure, void>> clear(String userId) async =>
      handleRepositoryExceptions(() async {
        await dataSource.clearCart(userId);
      });
}
