import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/shop_data_source.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../../common/presentation/controller/product_provider.dart';

// -------------------- Data Source + Repo --------------------

final Provider<ShopDataSource> shopDataSourceProvider =
    Provider<ShopDataSource>(
      (ref) => ShopDataSourceImpl(ref.read(firestoreServicesProvider)),
    );

final Provider<ShopRepository> shopRepositoryProvider =
    Provider<ShopRepository>(
      (ref) => ShopRepositoryImpl(ref.read(shopDataSourceProvider)),
    );
