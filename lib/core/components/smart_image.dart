import 'package:flutter/material.dart';

class SmartImage extends StatefulWidget {
  final String filename;

  const SmartImage({super.key, required this.filename});

  @override
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  late String currentUrl;
  int _attempt = 0;
  bool _hasExtension = false;

  @override
  void initState() {
    super.initState();
    print("filename : ${widget.filename}");
    _hasExtension = widget.filename.contains('.');
    _setUrl();
  }

  void _setUrl() {
    final baseUrl =
        'https://api.sinergiteknologi.co.id/ApiVenusHR/public/images/permission/';
   
    if (_hasExtension) {
      currentUrl = '$baseUrl${widget.filename}';
    } else {
      if (_attempt == 0) {
        currentUrl = '$baseUrl${widget.filename}.jpg';
      } else if (_attempt == 1) {
        currentUrl = '$baseUrl${widget.filename}.png';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showFullScreenImage(String imageUrl) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 3,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {
        _showFullScreenImage(currentUrl);
      },
      child: Image.network(
        currentUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;

          return Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              const CircularProgressIndicator(),
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (!_hasExtension && _attempt < 1) {
            setState(() {
              _attempt++;
              _setUrl();
            });
            return const SizedBox(); // sementara kosong saat retry
          } else {
            return const Icon(Icons.broken_image, size: 40);
          }
        },
      ),
    );
  }
}
