# Home Feature - Quick Reference Guide

##  Quick Start

### Wire Providers
```dart
final saleProducts = saleProductsProvider; // StreamProvider<List<ProductEntity>>
final newProducts = newProductsProvider;   // StreamProvider<List<ProductEntity>>
```

### Use in UI
```dart
// Section bound to a provider
HomeHorizontalListViewSection(
  title: AppStrings.kSale,
  subtitle: AppStrings.kSuperSummerSale,
  onSeeAll: () => context.push(AppRoutes.seeAll, extra: {'type': 'sale'}),
  productProvider: saleProductsProvider,
)
```

## 📋 Common Tasks

### 1) Show Home Screen
```dart
context.go(AppRoutes.home);
```

### 2) Navigate to Product Details
```dart
context.push(AppRoutes.productDetails, extra: productEntity);
```

### 3) Update Product (Admin/Backoffice)
```dart
await ref.read(updateProductUseCaseProvider).execute(
  id: productId,
  data: {'isInStock': true},
);
```

### 4) Read Streams in Widgets
```dart
Consumer(builder: (context, ref, _) {
  final async = ref.watch(saleProductsProvider);
  return async.when(
    data: (items) => ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (_, i) => HomeListViewItem(items[i]),
    ),
    loading: () => HorizontalShimmerList(itemCount: 3, itemWidth: 160),
    error: (err, __) => Text(err.toString()),
  );
});
```

## 🧩 Providers
```dart
// Data source and repository
final homeDataSourceProvider = Provider<HomeDataSource>(
  (ref) => HomeDataSourceImpl(ref.read(firestoreServicesProvider)),
);
final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(homeDataSourceProvider)),
);

// Use cases
final getSaleUsecaseProvider = Provider<GetSaleUsecase>(
  (ref) => GetSaleUsecase(ref.read(homeRepositoryProvider)),
);
final getNewUsecaseProvider = Provider<GetNewUsecase>(
  (ref) => GetNewUsecase(ref.read(homeRepositoryProvider)),
);

// Streams
final saleProductsProvider = StreamProvider<List<ProductEntity>>(
  (ref) => ref.read(getSaleUsecaseProvider).execute(),
);
final newProductsProvider = StreamProvider<List<ProductEntity>>(
  (ref) => ref.read(getNewUsecaseProvider).execute(),
);
```

## 🧭 Navigation
```dart
// FAB in HomeView
FloatingActionButton(
  tooltip: AppStrings.kVisualSearch,
  onPressed: () => context.push(AppRoutes.search),
  child: const Icon(Icons.image_search_outlined),
)
```

## 💡 UI Snippets
```dart
// Discount chip visibility
if (product.discountValue != 0) DiscountText(product.discountValue);

// Price formatting with strike-through when discounted
ProductPrice(price: product.price, discountValue: product.discountValue);

// Favorites toggle (inside item)
HomeFavoriteWidget(product: product);
```

## ⚠️ Error Patterns
```dart
// Repository maps errors to Failure types
error: (error, _) => Text(
  error is Failure ? error.message : error.toString(),
)
```

## 🔬 Testing Targets
- **Streams**: Emit data/empty/error states
- **Widgets**: `HomeHorizontalListViewSection` loading/data/error UI
- **Navigation**: Item tap routes to details

---

Last updated: August 17, 2025
Version: 1.0.0


