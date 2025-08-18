# Home Feature Documentation

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [API Reference](#api-reference)
- [Usage Guide](#usage-guide)
- [UI Overview](#ui-overview)
- [Error Handling](#error-handling)
- [Performance](#performance)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview

The Home feature provides the storefront landing experience: promotional banner, curated product carousels (Sale and New), and navigation entry points to product discovery and details. It follows Clean Architecture and uses Riverpod for state management. Data is sourced from Firestore through a typed data source and repository layer.

### Key Characteristics
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: Riverpod providers (Provider/StreamProvider/StateNotifier)
- **Data Source**: Firestore via `FirestoreServices`
- **Entities/Models**: `ProductEntity` (domain), `ProductModel` (data)
- **Navigation**: `go_router` with `AppRoutes`

### Primary User Journeys
- View promotional banner and curated lists
- Jump to "See All" to browse full collections with filters applied
- Navigate to product details from a carousel item

## Architecture

### Folder Structure
```
lib/features/home/
├── data/
│   ├── datasources/
│   │   └── home_data_source.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── home_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product_entity.dart
│   ├── repositories/
│   │   └── home_repository.dart
│   └── usecases/
│       ├── get_new_usecase.dart
│       ├── get_sale_usecase.dart
│       └── update_product_usecase.dart
└── presentation/
    ├── controller/
    │   ├── home_provider.dart
    │   └── product_details_provider.dart
    ├── views/
    │   ├── home_view.dart
    │   └── product_details_view.dart
    └── widgets/
        ├── home_banner.dart
        ├── home_horizontal_list_view_section.dart
        ├── home_list_view_header.dart
        ├── home_list_view_item.dart
        ├── home_view_body.dart
        ├── product_details_image_slider.dart
        ├── product_details_info.dart
        ├── product_details_view_body.dart
        ├── select_field.dart
        └── size_color_favorite_selector.dart
```

### Layer Responsibilities

#### 1. Domain Layer
- **Entities**: `ProductEntity` encapsulates core product attributes
- **Repositories**: `HomeRepository` exposes abstract read/update operations
- **Use Cases**: `GetSaleUsecase`, `GetNewUsecase`, `UpdateProductUsecase`

#### 2. Data Layer
- **Data Source**: `HomeDataSource` streams curated product lists and reads single product; performs updates
- **Models**: `ProductModel` maps Firestore documents to domain
- **Repository Impl**: `HomeRepositoryImpl` bridges domain and data with error mapping

#### 3. Presentation Layer
- **Controllers**: Riverpod providers wiring data streams and actions
- **Views**: Page scaffolds (`HomeView`, `ProductDetailsView`)
- **Widgets**: Composable UI pieces for banner, lists, and items

## Features

### Curated Product Carousels
- **Sale products**: Products where `discountValue != 0` (limited set)
- **New products**: Recent products sorted by `createdAt desc` (limited set)

### Product Details Entry
- Tap a product card to open `ProductDetailsView` with a hero transition

### Favorites Integration
- Heart icon toggles favorite status using the Favorites controller; optimizes rebuilds via Riverpod `select`

### See All Navigation
- "View All" applies a default filter (`gender: 'all'`) and routes to the shop listing screen

## API Reference

### Domain Interfaces

#### HomeRepository
```dart
abstract class HomeRepository {
  Stream<List<ProductEntity>> saleProducts();
  Stream<List<ProductEntity>> newProducts();
  Future<void> updateProduct({ required String id, required Map<String, dynamic> data });
  Future<Either<Failure, ProductEntity>> getProductById(String productId);
}
```

### Use Cases
- `GetSaleUsecase.execute(): Stream<List<ProductEntity>>`
- `GetNewUsecase.execute(): Stream<List<ProductEntity>>`
- `UpdateProductUsecase.execute({id, data}): Future<void>`

### Data Source
```dart
abstract class HomeDataSource {
  Stream<List<ProductModel>> saleProducts();
  Stream<List<ProductModel>> newProducts();
  Future<void> updateProduct({ required String id, required Map<String, dynamic> data });
  Future<ProductModel> getProductById(String productId);
}
```

### Riverpod Providers
```dart
final homeDataSourceProvider = Provider<HomeDataSource>((ref) => HomeDataSourceImpl(ref.read(firestoreServicesProvider)));
final homeRepositoryProvider = Provider<HomeRepository>((ref) => HomeRepositoryImpl(ref.read(homeDataSourceProvider)));
final getSaleUsecaseProvider = Provider<GetSaleUsecase>((ref) => GetSaleUsecase(ref.read(homeRepositoryProvider)));
final getNewUsecaseProvider = Provider<GetNewUsecase>((ref) => GetNewUsecase(ref.read(homeRepositoryProvider)));
final saleProductsProvider = StreamProvider<List<ProductEntity>>((ref) => ref.read(getSaleUsecaseProvider).execute());
final newProductsProvider = StreamProvider<List<ProductEntity>>((ref) => ref.read(getNewUsecaseProvider).execute());
final updateProductUseCaseProvider = Provider<UpdateProductUsecase>((ref) => UpdateProductUsecase(ref.read(homeRepositoryProvider)));
```

## Usage Guide

### 1) Display Home Screen
```dart
// In your router:
GoRoute(
  path: AppRoutes.home,
  builder: (_, __) => const HomeView(),
)
```

```dart
// HomeView UI basics
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton(
      tooltip: AppStrings.kVisualSearch,
      onPressed: () => context.push(AppRoutes.search),
      child: const Icon(Icons.image_search_outlined),
    ),
    body: const HomeViewBody(),
  );
}
```

### 2) Render Curated Lists
```dart
// Each section binds to a StreamProvider of products
HomeHorizontalListViewSection(
  title: AppStrings.kSale,
  subtitle: AppStrings.kSuperSummerSale,
  onSeeAll: () { /* set filter, navigate */ },
  productProvider: saleProductsProvider,
)
```

### 3) Navigate to Product Details
```dart
// From an item card
context.push(AppRoutes.productDetails, extra: productEntity);
```

### 4) Update a Product (Admin/Backoffice flows)
```dart
// Via UpdateProductUsecase
final usecase = ref.read(updateProductUseCaseProvider);
await usecase.execute(id: productId, data: { 'isInStock': true });
```

## UI Overview

### Components
- **`HomeBanner`**: Static banner with background image and headline
- **`HomeHorizontalListViewSection`**: Title, subtitle, View All action, and horizontal list bound to a StreamProvider
- **`HomeListViewItem` / `ProductItem`**: Image, favorite button, rating/reviews, price with discount formatting
- **`HomeListViewHeader`**: Typography for section headers

### Visual Behaviors
- Hero animation from list item into details view (tag = product id)
- Shimmer placeholder list while loading
- Discount chip shown when `discountValue > 0`

## Error Handling

### Repository Error Mapping
The repository maps exceptions into typed `Failure`s (e.g., `FirestoreFailure`, `SocketFailure`, `ServerFailure`) so UI can render friendly messages.

```dart
Stream<List<ProductModel>> newProducts() async* {
  try {
    yield* homeDataSource.newProducts();
  } on FirebaseException catch (e) {
    yield* Stream.error(FirestoreFailure.fromCode(e.message ?? 'Firebase error'));
  } on SocketException {
    yield* Stream.error(SocketFailure.fromCode('No internet connection'));
  } on FormatException {
    yield* Stream.error(const ServerFailure('Data format error'));
  } catch (e) {
    yield* Stream.error(Failure('Unexpected error: $e'));
  }
}
```

### UI Error Rendering
```dart
ref.watch(productProvider).when(
  data: (data) => ListView(...),
  error: (error, _) => Text(
    error is Failure ? error.message : error.toString(),
  ),
  loading: () => HorizontalShimmerList(...),
);
```

## Performance

### Stream Consumption
- Use `StreamProvider` to bind Firestore streams with automatic lifecycle management

### Rebuild Optimizations
- Use Riverpod `select` to watch derived slices (e.g., favorite membership) and minimize rebuilds
- Keep list items lightweight; defer expensive work

### Rendering Optimizations
- Constrain item sizes and use `ClipRRect`/`CachedImage` for efficient painting
- Use shimmer placeholders to avoid layout jank

## Testing

### Recommended Areas
- **Use case tests**: Ensure streams are forwarded and errors mapped
- **Repository tests**: Error mapping across Firebase/Socket/Format/Unknown
- **Widget tests**: Loading/empty/data/error states for `HomeHorizontalListViewSection`
- **Navigation tests**: Tap item navigates to `ProductDetailsView`

### Example: Widget State Triad
```dart
testWidgets('Home section renders loading → data → error', (tester) async {
  // Arrange a ProviderScope with overridden product stream
  // Pump widget and assert shimmer, then data items, then error text
});
```

## Troubleshooting

### No Products Shown
```
Problem: Lists are empty
Checks:
- Ensure Firestore has documents in `products` collection
- Verify security rules permit read access
- Confirm `discountValue` set for sale items and `createdAt` indexed
```

### Stream Errors
```
Problem: Error state with Firestore message
Checks:
- Review network connectivity
- Validate indexes for queried fields (`discountValue`, `createdAt`)
- Inspect mapped failure message in logs
```

### Navigation Not Working
```
Problem: Tapping product does nothing
Checks:
- Verify `AppRoutes.productDetails` is registered
- Ensure `extra` is a `ProductEntity` compatible with the details screen constructor
```

## Contributing

### Adding a New Curated Section
1. Create a new use case in `domain/usecases/`
2. Extend `HomeDataSource` and `HomeRepository` contracts if needed
3. Implement query in `HomeDataSourceImpl` (remember Firestore indexing)
4. Expose a `StreamProvider` in `home_provider.dart`
5. Reuse `HomeHorizontalListViewSection` with the new provider
6. Add tests for empty/data/error states and error mapping

## Changelog

### v1.0.0 (Current)
- Initial documentation for Home feature
- Covers architecture, APIs, usage, and troubleshooting

## License

This Home feature is part of the E-Commerce application. Refer to the main project license for usage terms.

---

Last updated: August 17, 2025
Version: 1.0.0


