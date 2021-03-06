import 'package:flutter/material.dart';
import 'package:flutterbook/core/controllers/posts_controller.dart';
import 'package:flutterbook/features/home_page/models/post_model.dart';
import 'package:flutterbook/features/home_page/widgets/post_tile.dart';
import 'package:get/get.dart';

class HomeContent extends StatelessWidget {
  final PostsController _postsController;
  HomeContent(this._postsController);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _postsController.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _postsController.posts.length == 0
              ? Center(
                  child: Text(
                    "Nenhuma postagem encontrada",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _postsController.posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = _postsController.posts[index];
                    return PostTile(post);
                  },
                ),
    );
  }
}
