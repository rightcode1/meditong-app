import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';

class CachedImageWithSkeleton extends StatelessWidget {
  final String imageUrl;

  /// Default: BoxFit.cover
  final BoxFit fit;

  const CachedImageWithSkeleton({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const SkeletonAvatar(
        style: SkeletonAvatarStyle(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: fit,
    );
  }
}
