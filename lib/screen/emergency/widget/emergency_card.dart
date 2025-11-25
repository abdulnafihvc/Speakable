import 'package:flutter/material.dart';
import 'package:speakable/services/google_tts_service.dart';

class EmergencyCard extends StatefulWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String message;
  final Color color;

  const EmergencyCard({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    required this.message,
    required this.color,
  }) : assert(
         icon != null || imagePath != null,
         'Either icon or imagePath must be provided',
       );

  @override
  State<EmergencyCard> createState() => _EmergencyCardState();
}

class _EmergencyCardState extends State<EmergencyCard> {
  late GoogleTtsService _googleTts;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _googleTts = GoogleTtsService();
  }

  Future<void> _speakMessage() async {
    // Speak the message once
    await _googleTts.speak(text: widget.message, languageCode: 'en-US');
  }

  @override
  void dispose() {
    _googleTts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _speakMessage,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            // RESIZE CARD: Change padding value to adjust card internal size (currently 20)
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.color.withOpacity(0.1),
                  widget.color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.imagePath != null
                    ? Container(
                        // RESIZE CARD: Change width/height to adjust image size (currently 90)
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.color.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            widget.imagePath!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon!,
                          // RESIZE CARD: Change icon size (currently 40)
                          size: 40,
                          color: widget.color,
                        ),
                      ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    // RESIZE CARD: Change title font size (currently 17.5)
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      // RESIZE CARD: Change message font size (currently 14)
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
