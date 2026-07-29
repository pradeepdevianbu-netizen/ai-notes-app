import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final String imageUrl;
  final bool isMe;

  const ImageMessage({
    super.key,
    required this.imageUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImage(
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Hero(
        tag: imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            imageUrl,
            width: 220,
            fit: BoxFit.cover,
            loadingBuilder: (
              context,
              child,
              loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return const SizedBox(
                width: 220,
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                width: 220,
                height: 220,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: Image.network(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}