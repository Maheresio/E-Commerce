import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImageWidget extends StatelessWidget {
  const CacheImageWidget({super.key, required this.imgUrl});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: double.infinity,
      imageUrl: imgUrl,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const ColoredBox(color: Colors.white),
          ),
      errorWidget:
          (context, url, error) => ColoredBox(
            color: Colors.grey[200]!,
            child: const Icon(Icons.error_outline, color: Colors.grey),
          ),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 200),
      memCacheWidth: (MediaQuery.of(context).size.width * 2).round(),
      maxHeightDiskCache: 1000,
      useOldImageOnUrlChange: true,
      httpHeaders: const {
        'Cache-Control': 'max-age=604800', // 1 week
      },
    );
  }
}
