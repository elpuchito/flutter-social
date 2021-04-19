import 'package:flutter/material.dart';
import 'package:flutter_social_app/widgets/custom_image.dart';
import 'package:flutter_social_app/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
