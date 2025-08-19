# Search Feature - Quick Reference

## Common Tasks

### Open Visual Search
```dart
context.push(AppRoutes.search);
```

### Pick Image from Camera/Gallery
```dart
ref.read(selectImageControllerProvider).imageSelectionHandler(
  context, 
  ImageSource.camera, // or ImageSource.gallery
);
```

### Process Cropped Image
```dart
// Inside CropImageView after user confirms crop
ref.read(searchProvider.notifier).processImage(croppedBytes);
context.pop();
context.push(AppRoutes.searchResult);
```

### Search by Specific Tags
```dart
final fetch = getSearchByTagsFetch(ref, ["denim", "jacket"]);
final state = ref.watch(searchPaginationProvider(fetch));
```

## Configuration

### Confidence Threshold
- Location: `GetClothesTagsUsecase`
- Current value: 0.8
- How to change: Modify the filter condition in `getClothesTags`

### Tag Mappings
- Location: `_normalizeTags()` method
- Purpose: Maps Clarifai concepts to application tags

### Fallback Categories
- Location: `searchProductsByTags()`
- Look for: `broadCategories` list

## Common Issues

### Image Upload Fails
- Check Supabase credentials in `.env`
- Verify internet connection
- Check file size limits

### No Search Results
- Verify Clarifai API keys
- Check if tags are being properly extracted
- Review confidence threshold

### Performance Issues
- Check network conditions
- Review image sizes
- Monitor Firestore query performance

## Dependencies
- `dio`: HTTP client
- `supabase_flutter`: Storage and authentication
- `riverpod`: State management
- `crop_image`: Image cropping
- `go_router`: Navigation
- `firebase_core` & `cloud_firestore`: Database operations
