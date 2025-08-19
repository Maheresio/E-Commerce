# Search Feature - Technical Reference

## Architecture
####  Folder Structure
```
lib/features/search/
├── data/
│   ├── datasources/
│   │   └── search_remote_data_source.dart
│   └── repositories/
│       └── search_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── search_repository.dart
│   └── usecases/
│       ├── clear_all_images_usecase.dart
│       ├── delete_image_usecase.dart
│       ├── get_clothes_tags_usecase.dart
│       ├── search_products_by_tags.dart
│       └── upload_image_usecase.dart
└── presentation/
    ├── providers/
    │   ├── crop_image_controller.dart
    │   ├── search_provider.dart
    │   └── select_image_controller.dart
    ├── views/
    │   ├── crop_image_view.dart
    │   ├── search_result_view.dart
    │   └── search_view.dart
    └── widgets/
        └── search_view_body.dart
```

The search feature follows Clean Architecture with three main layers:

### Data Layer
- `SearchRemoteDataSourceImpl`: Handles network and database operations
- `SearchRepositoryImpl`: Implements the repository interface
- Services:
  - `SupabaseStorageService`: Manages image uploads
  - `FirestoreServices`: Handles product queries
  - `DioClient`: Manages HTTP requests to Clarifai API

### Domain Layer
- `SearchRepository` (interface)
- Use Cases:
  - `UploadImageUsecase`: Handles image upload to Supabase
  - `GetClothesTagsUsecase`: Processes images with Clarifai
  - `SearchProductsByTagsUseCase`: Queries Firestore for matching products
  - `ClearAllImagesUsecase`: Cleans up uploaded images

### Presentation Layer
- State Management:
  - `SearchNotifier`: Manages search state and business logic
  - `SelectImageController`: Handles image selection
  - `CropImageController`: Manages image cropping
- Views:
  - `SearchView`: Main search entry point
  - `CropImageView`: Image cropping interface
  - `SearchResultView`: Displays search results

## Data Flow

1. User selects/takes a photo
2. Image is optionally cropped
3. Image is uploaded to Supabase Storage
4. Public URL is sent to Clarifai for tag extraction
5. Extracted tags are used to query Firestore
6. Results are displayed to the user

## Configuration

### Environment Variables
```env
# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key

# Clarifai
CLARIFAI_BASE_URL=https://api.clarifai.com/v2
CLARIFAI_APP_ID=your_app_id
CLARIFAI_USER_ID=your_user_id
CLARIFAI_MODEL_ID=your_model_id
CLARIFAI_MODEL_VERSION_ID=your_version_id
CLARIFAI_API_KEY=your_api_key
```

### Android Permissions
- `CAMERA`
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`

### iOS Info.plist
- `NSCameraUsageDescription`
- `NSPhotoLibraryUsageDescription`

## Error Handling

### Common Error Types
- `ServerFailure`: API errors from Clarifai
- `SocketFailure`: Network connectivity issues
- `FirestoreFailure`: Database operation failures
- `StorageFailure`: File upload/download errors

### Error Messages
- No internet: "A network error occurred. Please check your connection."
- API errors: Display server message or fallback to generic error
- Storage/Database: Log detailed error, show user-friendly message

## Testing

### Unit Tests
- Test each use case in isolation
- Mock dependencies (Firestore, Clarifai, Supabase)
- Test error conditions and edge cases

### Widget Tests
- Test UI components with mocked state
- Verify loading/empty/error states
- Test user interactions

### Integration Tests
- Test complete search flow
- Verify API and database interactions
- Test error recovery
