

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../responsive/pixel_perfect.dart';
import '../dotted_border_painter.dart';
import '../field_title.dart';

class UploadPhotoWidget extends StatefulWidget {
  const UploadPhotoWidget({super.key,this.initialPhoto, required this.title,required this.getFileName});
  final String? initialPhoto;
  final String title;
  final Function(String?) getFileName;

  @override
  State<UploadPhotoWidget> createState() => _UploadPhotoWidgetState();
}

class _UploadPhotoWidgetState extends State<UploadPhotoWidget> {
  String? fileName;

  @override
  initState(){
    fileName = widget.initialPhoto;
    super.initState();
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,

    );
    if (result != null) {
      setState(() {
        fileName = result.files.single.path;
        widget.getFileName(fileName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldTitle(
          "Upload Photo",
        ),
        addH(8.h),
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: selectFile,
          child: CustomPaint(
            painter: DottedBorderPainter(
              color: const Color(0xffD8E0EC),
            ),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: fileName == null
                        ? Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined,
                            size: 40,
                            color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.center,
                          "Select ${widget.title} (256 * 256)\nMax file size 256KB",
                          style: const TextStyle(
                              color: Colors.grey),
                        ),
                      ],
                    )
                        : Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: fileName!.contains(
                          'https://') &&
                          widget.initialPhoto != null
                          ? Image.network(
                          widget.initialPhoto!)
                          : Image.file(
                        fit: BoxFit.cover,
                        File(fileName!),
                      ),
                    ),
                  ),
                  if(fileName != null)Positioned(
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            fileName = null;
                          });
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          color: AppColors.error,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
