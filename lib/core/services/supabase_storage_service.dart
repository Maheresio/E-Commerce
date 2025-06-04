// File: supabase_storage_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'uploaded-images';

  Future<String> uploadImage({
    required File file,
    required String filePathInBucket,
  }) async {
    final StorageFileApi storageRef = _supabase.storage.from(_bucketName);

    await storageRef.upload(
      filePathInBucket,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    return storageRef.getPublicUrl(filePathInBucket);
  }

  // ✅ New method for Uint8List
  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String filePathInBucket,
    String contentType = 'image/png',
  }) async {
    final storageRef = _supabase.storage.from(_bucketName);

    await storageRef.uploadBinary(
      filePathInBucket,
      bytes,
      fileOptions: FileOptions(contentType: contentType, upsert: true),
    );

    return storageRef.getPublicUrl(filePathInBucket);
  }
}
