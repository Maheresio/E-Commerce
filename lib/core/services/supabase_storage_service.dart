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
    final storageRef = _supabase.storage.from(_bucketName);

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
    final StorageFileApi storageRef = _supabase.storage.from(_bucketName);

    await storageRef.uploadBinary(
      filePathInBucket,
      bytes,
      fileOptions: FileOptions(contentType: contentType, upsert: true),
    );

    return storageRef.getPublicUrl(filePathInBucket);
  }

  // ✅ Method to delete uploaded images
  Future<void> deleteFile(String filePathInBucket) async {
    final StorageFileApi storageRef = _supabase.storage.from(_bucketName);

    await storageRef.remove(<String>[filePathInBucket]);
  }

  // ✅ Method to clear all files in the bucket
  Future<void> clearAllFiles() async {
    final StorageFileApi storageRef = _supabase.storage.from(_bucketName);

    // List all files in the bucket
    final List<FileObject> filesList = await storageRef.list();

    if (filesList.isNotEmpty) {
      // Extract file names from the list
      final List<String> fileNames = filesList.map((FileObject file) => file.name).toList();

      // Remove all files at once
      await storageRef.remove(fileNames);
    }
  }
}
