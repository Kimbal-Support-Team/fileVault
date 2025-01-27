
import 'package:flutter/material.dart';


IconData getFileTypeIcon(String? fileName) {
  final extension = fileName?.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'PxP':
    case 'txt':
      return Icons.text_snippet;
    case 'xls':
    case 'xlsx':
    case 'csv':
      return Icons.table_chart;
    case 'sql':
      return Icons.code;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Icons.image;
    case 'mp4':
    case 'mkv':
    case 'avi':
      return Icons.movie;
    case 'mp3':
    case 'wav':
      return Icons.audiotrack;
    case 'zip':
    case 'rar':
      return Icons.archive;
    case 'exe':
      return Icons.security;
    default:
      return Icons.device_unknown_sharp;
  }
}
