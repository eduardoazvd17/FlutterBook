import 'dart:math';
import 'package:flutterbook/core/repositories/api_repository.dart';
import 'package:flutterbook/features/home_page/models/post_model.dart';
import 'package:flutterbook/features/home_page/models/user_model.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final ApiRepository _repository;
  PostsController(this._repository);

  // On Init -> Load API Posts.
  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadPostsFromApi();
  }

  //Mocked User
  UserModel get user => UserModel(
        id: "1",
        name: "Eduardo Azevedo",
        imageUrl:
            "https://avatars.githubusercontent.com/u/49172682?s=400&u=12df3b8878007a0b6f48d7d5d9555cb784191218&v=4",
      );

  //Loading Control
  RxBool _loading = false.obs;
  bool get loading => _loading.value;

  //Filter Control
  RxString _filter = "".obs;
  String get filter => _filter.value;
  changeFilter(String text) => _filter.value = text;
  clearFilter() => _filter.value = "";

  //SearchBox Control
  RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  toggleSearch() {
    clearFilter();
    _isSearching.value = !_isSearching.value;
  }

  //Posts Control
  RxList _posts = [].obs;

  List get posts {
    _posts.value.sort((a, b) => b.date.compareTo(a.date));
    if (_filter.value == "") {
      return _posts;
    } else {
      return _posts
          .where(
            (element) =>
                (element.text
                    .toLowerCase()
                    .contains(_filter.value.toLowerCase())) ||
                (element.user.name
                    .toLowerCase()
                    .contains(_filter.value.toLowerCase())),
          )
          .toList();
    }
  }

  List get myPosts {
    return posts.where((element) => element.user.id == user.id).toList();
  }

  _loadPostsFromApi() async {
    _loading.value = true;
    _posts.value = await _repository.getPosts();
    _loading.value = false;
  }

  createPost(String text) {
    var random = new Random();
    var id = random.nextInt(999999) + _posts.length;
    _posts.add(
      PostModel(
        id: "$id",
        answers: 0,
        date: DateTime.now(),
        user: user,
        text: text,
      ),
    );
  }

  editPost(String id, String newText) {
    PostModel post = _posts.singleWhere((element) => element.id == id);
    _posts.remove(post); // Remove post antigo.
    post.text = newText;
    post.isEdited = true;
    _posts.add(post); // Adiciona post modificado
  }

  deletePost(PostModel post) => _posts.remove(post);
}
