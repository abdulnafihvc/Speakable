import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:speakable/models/user_document.dart';
import 'profile_section_card.dart';

class DocumentsSection extends StatelessWidget {
  final Box<UserDocument> documentsBox;
  final bool isEditMode;
  final VoidCallback? onUploadPressed;
  final Function(int)? onDeleteDocument;

  const DocumentsSection({
    super.key,
    required this.documentsBox,
    this.isEditMode = false,
    this.onUploadPressed,
    this.onDeleteDocument,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionCard(
      title: 'DOCUMENTS',
      icon: Icons.folder_outlined,
      accentColor: Colors.amberAccent,
      trailing: isEditMode
          ? ElevatedButton.icon(
              onPressed: onUploadPressed,
              icon: const Icon(Icons.upload_file, size: 16),
              label: const Text('UPLOAD'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black,
                elevation: 5,
                shadowColor: Colors.amberAccent.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          : null,
      child: ValueListenableBuilder(
        valueListenable: documentsBox.listenable(),
        builder: (context, Box<UserDocument> box, _) {
          if (box.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color:
                    isDark ? Colors.white.withOpacity(0.02) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[300]!,
                    style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.folder_open, size: 48, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'No documents found',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: box.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final document = box.getAt(index);
              if (document == null) return const SizedBox.shrink();

              return DocumentCard(
                document: document,
                index: index,
                isEditMode: isEditMode,
                onDelete: onDeleteDocument,
              );
            },
          );
        },
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final UserDocument document;
  final int index;
  final bool isEditMode;
  final Function(int)? onDelete;

  const DocumentCard({
    super.key,
    required this.document,
    required this.index,
    this.isEditMode = false,
    this.onDelete,
  });

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.green;
      case 'txt':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fileColor = _getFileColor(document.fileType);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fileColor.withOpacity(isDark ? 0.3 : 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: fileColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: fileColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: fileColor.withOpacity(0.2)),
            ),
            child: Icon(
              _getFileIcon(document.fileType),
              color: fileColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      document.fileSizeFormatted,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd, yyyy').format(document.uploadDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => onDelete?.call(index),
              tooltip: 'Delete',
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: fileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: fileColor.withOpacity(0.3)),
              ),
              child: Text(
                document.fileExtension.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: fileColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
