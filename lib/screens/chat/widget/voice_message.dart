import 'package:flutter/material.dart';

class VoiceMessage extends StatelessWidget {
  final bool isMe;
  final Duration duration;
  final bool isPlaying;
  final VoidCallback onPlay;

  const VoiceMessage({
    super.key,
    required this.isMe,
    required this.duration,
    required this.isPlaying,
    required this.onPlay,
  });

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [

          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(25),
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  isMe
                      ? Colors.white24
                      : Colors.blue,
              child: Icon(
                isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              children: [

                LinearProgressIndicator(
                  value: isPlaying ? .5 : 0,
                  borderRadius:
                      BorderRadius.circular(20),
                  minHeight: 5,
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _format(duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe
                          ? Colors.white70
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}