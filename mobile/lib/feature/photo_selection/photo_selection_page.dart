import 'package:fodie_ai/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:fodie_ai/feature/ai_chat/ai_chat.dart';

class PhotoSelectionPage extends StatefulWidget {
  const PhotoSelectionPage({super.key});

  @override
  State<PhotoSelectionPage> createState() => _PhotoSelectionPageState();
}

class _PhotoSelectionPageState extends State<PhotoSelectionPage> {
  final List<XFile> _selectedPhotos = [];
  final int _maxPhotos = 10;
  
  @override
  void initState() {
    super.initState();
    _takePhoto();
  }
  
  Future<void> _takePhoto() async {
    if (_selectedPhotos.length >= _maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum ${_maxPhotos} photos allowed')),
      );
      return;
    }
    
    final cameraService = getIt<CameraService>();
    final photo = await cameraService.takePhoto();
    
    if (photo != null) {
      setState(() {
        _selectedPhotos.add(photo);
      });
    }
  }
  
  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }
  
  void _continueWithPhotos() {
    if (_selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one photo')),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AIChatPage(selectedPhotos: _selectedPhotos),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Photos (${_selectedPhotos.length}/$_maxPhotos)'),
        actions: [
          if (_selectedPhotos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _continueWithPhotos,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedPhotos.isEmpty
                ? Center(
                    child: Text(
                      'No photos selected',
                      style: pageHeaderSmallStyle,
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(8.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.r,
                      mainAxisSpacing: 8.r,
                    ),
                    itemCount: _selectedPhotos.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              File(_selectedPhotos[index].path),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.broken_image, size: 40.r),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 4.r,
                            right: 4.r,
                            child: GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  Assets.icons.cross,
                                  width: 16.r,
                                  height: 16.r,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: SvgPicture.asset(
                Assets.icons.camera,
                width: 24.r,
                height: 24.r,
              ),
              label: Text('Take Photo (${_selectedPhotos.length}/$_maxPhotos)'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}