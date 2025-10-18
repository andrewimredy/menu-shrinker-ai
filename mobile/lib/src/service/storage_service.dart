import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

@lazySingleton
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Uploads a single image to Firebase Storage
  /// Returns the download URL of the uploaded image
  Future<String> uploadImage(XFile image, {String? customFileName}) async {
    final fileName = customFileName ?? '${_uuid.v4()}${path.extension(image.path)}';
    final destination = 'images/$fileName';
    final ref = _storage.ref(destination);
    
    final uploadTask = ref.putFile(File(image.path));
    final snapshot = await uploadTask;
    
    return await snapshot.ref.getDownloadURL();
  }

  /// Uploads multiple images to Firebase Storage
  /// Returns a list of download URLs for the uploaded images
  /// Provides progress updates through the onProgress callback
  Future<List<String>> uploadImages(
    List<XFile> images, {
    Function(double)? onProgress,
  }) async {
    if (images.isEmpty) return [];
    
    final List<String> urls = [];
    int completed = 0;
    
    for (final image in images) {
      try {
        final fileName = '${_uuid.v4()}${path.extension(image.path)}';
        final destination = 'images/$fileName';
        final ref = _storage.ref(destination);
        
        final uploadTask = ref.putFile(File(image.path));
        
        // Listen for progress updates
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = (completed + snapshot.bytesTransferred / snapshot.totalBytes) / images.length;
          onProgress?.call(progress);
        });
        
        final snapshot = await uploadTask;
        final url = await snapshot.ref.getDownloadURL();
        urls.add(url);
        
        completed++;
        onProgress?.call(completed / images.length);
      } catch (e) {
        debugPrint('Error uploading image: $e');
      }
    }
    
    return urls;
  }

  /// Uploads multiple images with progress tracking
  Future<List<String>> uploadImagesWithProgress(
    List<File> imageFiles, 
    Function(double) onProgressUpdate
  ) async {
    final List<String> downloadUrls = [];
    double totalProgress = 0;
    final double progressIncrement = 1 / imageFiles.length;
    
    for (final File imageFile in imageFiles) {
      final String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
      final Reference ref = _storage.ref().child('images/$fileName');
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final double fileProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        final double overallProgress = totalProgress + (fileProgress * progressIncrement);
        onProgressUpdate(overallProgress);
      });
      
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String url = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(url);
      
      totalProgress += progressIncrement;
      onProgressUpdate(totalProgress);
    }
    
    return downloadUrls;
  }

  /// Deletes an image from Firebase Storage by its URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting image: $e');
      rethrow;
    }
  }
}