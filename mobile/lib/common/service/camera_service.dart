import 'package:fodie_ai/common/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@injectable
class CameraService {
  final ImagePicker _picker = ImagePicker();
  
  /// Takes multiple photos from camera, limited by maxCount
  Future<List<XFile>?> takePhotos({
    required int maxCount,
    required BuildContext context,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      if (images.length > maxCount) {
        return images.sublist(0, maxCount);
      }
      
      return images;
    } catch (e) {
      debugPrint('Error taking photos: $e');
      return null;
    }
  }
  
  /// Takes a single photo from camera
  Future<XFile?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 80,
      );
      
      return photo;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }
  
  /// Takes multiple photos from camera, limited by maxCount
  Future<List<XFile>?> takeMultiplePhotos({
    required int maxCount,
  }) async {
    try {
      final List<XFile> photos = [];
      
      // Take first photo
      final XFile? firstPhoto = await takePhoto();
      if (firstPhoto != null) {
        photos.add(firstPhoto);
      } else {
        return null; // User cancelled
      }
      
      // Allow taking more photos up to maxCount
      while (photos.length < maxCount) {
        // Ask if user wants to take another photo
        // This would typically be handled by the UI
        final XFile? nextPhoto = await takePhoto();
        if (nextPhoto != null) {
          photos.add(nextPhoto);
        } else {
          break; // User cancelled
        }
      }
      
      return photos;
    } catch (e) {
      debugPrint('Error taking multiple photos: $e');
      return null;
    }
  }
}