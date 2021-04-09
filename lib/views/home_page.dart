import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/controllers/navigation_controller.dart';
import 'package:flutterbook/controllers/posts_controller.dart';
import 'package:flutterbook/widgets/main_layout.dart';
import 'package:flutterbook/widgets/new_post_modal.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final NavigationController _navigationController;
  final PostsController _postsController;
  HomePage(this._navigationController, this._postsController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _addButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => _navigationBar(),
      ),
      body: MainLayout(
        child: Obx(
          () => _navigationController.currentPage,
        ),
      ),
    );
  }

  _appBar() => AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 1,
        centerTitle: true,
        title: Obx(
          () => _postsController.isSearching
              ? TextField(
                  decoration: InputDecoration(
                    labelText: "Pesquisar...",
                  ),
                  onChanged: (text) => _postsController.changeFilter(text),
                )
              : Text(_navigationController.currentPageIndex == 1
                  ? "Meus Posts"
                  : "FlutterBook"),
        ),
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(_postsController.isSearching
                  ? Icons.close
                  : CupertinoIcons.search),
            ),
            onPressed: () => _postsController.toggleSearch(),
          ),
        ],
      );

  _addButton() => FloatingActionButton(
        child: Icon(
          CupertinoIcons.add,
          color: Get.theme.scaffoldBackgroundColor,
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: Get.context,
            builder: (_) => Padding(
              padding:
                  EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
              child: NewPostModal(
                Get.find<PostsController>(),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              ),
            ),
          );
        },
      );

  _navigationBar() => BottomNavigationBar(
        currentIndex: _navigationController.currentPageIndex,
        items: _navigationController.navigationItems,
        onTap: _navigationController.changePage,
      );
}
