import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    Key? key,
    required this.imageURL,
    required this.radius,
  }) : super(key: key);

  const ChatAvatar.large({
    Key? key,
    required this.imageURL,
  })  : radius = 44,
        super(key: key);

  final double radius;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(imageURL),
      backgroundColor: Colors.grey,
    );
  }
}
