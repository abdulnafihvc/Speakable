import 'package:flutter/material.dart';
import 'package:speakable/models/saved_message.dart';
import 'package:intl/intl.dart';

class SavedMessageCard extends StatelessWidget {
  final SavedMessage message;
  final VoidCallback onPlay;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final bool isPlaying;

  const SavedMessageCard({
    super.key,
    required this.message,
    required this.onPlay,
    required this.onDelete,
    required this.onEdit,
    required this.onCopy,
    required this.isPlaying,
  });

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                context,
                icon: Icons.copy,
                label: 'Copy Message',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  onCopy();
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.edit,
                label: 'Edit Message',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.delete,
                label: 'Delete Message',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onLongPress: () => _showOptionsMenu(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  onPressed: () => _showOptionsMenu(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'More options',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onPlay,
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow, size: 20),
                label: Text(isPlaying ? 'Stop' : 'Play'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPlaying ? Colors.red : primaryColor,
                  foregroundColor: isPlaying
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
