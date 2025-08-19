import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firestore_sevice.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../../home/data/models/product_model.dart';

abstract class SearchRemoteDataSource {
  Future<String> uploadImage(Uint8List bytes, String filePathInBucket);
  Future<List<String>> getClothesTags(String imageUrl);
  Future<void> deleteImage(String filePathInBucket);
  Future<void> clearAllImages();

  Future<List<ProductModel>> searchProductsByTags(
    List<String> tags, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl({
    required this.storageService,
    required this.dioClient,
    required this.firestore,
  });

  final SupabaseStorageService storageService;
  final DioClient dioClient;
  final FirestoreServices firestore;

  @override
  Future<String> uploadImage(Uint8List bytes, String filePathInBucket) async {
    return await storageService.uploadImageFromBytes(
      bytes: bytes,
      filePathInBucket: filePathInBucket,
    );
  }

  @override
  Future<void> deleteImage(String filePathInBucket) async {
    await storageService.deleteFile(filePathInBucket);
  }

  @override
  Future<void> clearAllImages() async {
    await storageService.clearAllFiles();
  }

  @override
  Future<List<String>> getClothesTags(String imageUrl) async {
    final Map<String, List<Map<String, Map<String, Map<String, String>>>>>
    requestData = <String, List<Map<String, Map<String, Map<String, String>>>>>{
      'inputs': <Map<String, Map<String, Map<String, String>>>>[
        <String, Map<String, Map<String, String>>>{
          'data': <String, Map<String, String>>{
            'image': <String, String>{'url': imageUrl},
          },
        },
      ],
    };

    final response = await dioClient.post(
      url: ApiConstants.getModelEndpoint(),
      headers: ApiConstants.headers,
      data: requestData,
    );

    if (response.statusCode == 200) {
      final outputs = response.data['outputs'];

      if (outputs != null && outputs.isNotEmpty) {
        final responseData = outputs[0]['data'];

        if (responseData != null && responseData.containsKey('concepts')) {
          final List concepts = responseData['concepts'] as List;

          // Extract tag names with confidence >= 0.8
          final List<String> tags =
              concepts
                  .where((concept) => concept['value'] >= 0.8)
                  .map<String>((concept) => concept['name'].toString())
                  .toList();

          // Normalize tags to match Firestore format
          return _normalizeTags(tags);
        }
      }
    }

    return <String>[];
  }

  @override
  Future<List<ProductModel>> searchProductsByTags(
    List<String> tags, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async {
    // Try multiple search strategies
    var results = <ProductModel>[];

    // Strategy 1: Direct tag match
    results = await firestore.getCollection(
      path: FirestoreConstants.products,
      builder:
          (
            Map<String, dynamic>? data,
            String id,
            DocumentSnapshot<Object?> doc,
          ) => ProductModel.fromMap(data!, id, doc),
      queryBuilder:
          (Query<Object?> query) => query.where('tags', arrayContainsAny: tags),
      lastDocument: lastDocument,
      pageSize: pageSize,
    );

    // Strategy 2: If no results, try individual tags
    if (results.isEmpty && tags.length > 1) {
      for (final String tag in tags) {
        final List<ProductModel> individualResults = await firestore
            .getCollection(
              path: FirestoreConstants.products,
              builder:
                  (
                    Map<String, dynamic>? data,
                    String id,
                    DocumentSnapshot<Object?> doc,
                  ) => ProductModel.fromMap(data!, id, doc),
              queryBuilder:
                  (Query<Object?> query) =>
                      query.where('tags', arrayContains: tag),
              lastDocument: lastDocument,
              pageSize: pageSize,
            );
        results.addAll(individualResults);
      }
    }

    // Strategy 3: If still no results, try broader categories
    if (results.isEmpty) {
      final List<String> broadCategories = <String>[
        'dress',
        'denim',
        'shirt',
        'pants',
        'jacket',
      ];
      for (final String category in broadCategories) {
        if (tags.any((String tag) => tag.toLowerCase().contains(category))) {
          final List<ProductModel> categoryResults = await firestore
              .getCollection(
                path: FirestoreConstants.products,
                builder:
                    (
                      Map<String, dynamic>? data,
                      String id,
                      DocumentSnapshot<Object?> doc,
                    ) => ProductModel.fromMap(data!, id, doc),
                queryBuilder:
                    (Query<Object?> query) =>
                        query.where('tags', arrayContains: category),
                pageSize: 3,
              );

          results.addAll(categoryResults);
        }
      }
    }

    // Remove duplicates and limit results
    final List<ProductModel> uniqueResults =
        results.toSet().take(pageSize).toList();

    return uniqueResults;
  }

  /// Normalize AI-extracted tags to match Firestore tag format
  List<String> _normalizeTags(List<String> aiTags) {
    final List<String> normalized = <String>[];

    for (final String tag in aiTags) {
      // Convert spaces to hyphens and make lowercase
      var normalizedTag = tag.toLowerCase().replaceAll(' ', '-');

      // Add some common mapping rules based on your Firestore tags
      final Map<String, String> tagMappings = <String, String>{
        'maxi-dress': 'dress',
        'chambray/denim': 'denim',
        'long-sleeve': 'long-sleeve',
        'short-sleeve': 'short-sleeve',
        't-shirt': 't-shirt',
        'v-neck': 'v-neck',
      };

      // Apply mappings if available, otherwise use normalized tag
      normalizedTag = tagMappings[normalizedTag] ?? normalizedTag;

      normalized.add(normalizedTag);

      // Also add the original tag as fallback
      if (normalizedTag != tag.toLowerCase()) {
        normalized.add(tag.toLowerCase());
      }

      // Add some broader category fallbacks
      if (tag.contains('dress')) {
        normalized.add('dress');
      }
      if (tag.contains('denim') || tag.contains('chambray')) {
        normalized.add('denim');
      }
      if (tag.contains('shirt')) {
        normalized.add('shirt');
      }
      if (tag.contains('sleeve')) {
        normalized.add('sleeve');
      }
    }

    // Remove duplicates
    return normalized.toSet().toList();
  }
}
