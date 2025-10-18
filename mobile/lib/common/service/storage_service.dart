import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

@lazySingleton
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Uploads a single image to Firebase Storage and returns the download URL
  Future<String> uploadImage(File imageFile) async {
    final String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
    final Reference ref = _storage.ref().child('images/$fileName');
    
    final UploadTask uploadTask = ref.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    
    return await taskSnapshot.ref.getDownloadURL();
  }

  /// Uploads multiple images to Firebase Storage and returns a list of download URLs
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    final List<String> downloadUrls = [];
    
    for (final File imageFile in imageFiles) {
      final String url = await uploadImage(imageFile);
      downloadUrls.add(url);
    }
    
    return downloadUrls;
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

  /// Deletes an image from Firebase Storage by URL
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}