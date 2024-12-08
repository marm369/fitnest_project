import 'package:get/get.dart';
import '../models/post_model.dart';
import '../service/PostService.dart';

class PostController extends GetxController {
  final PostService postService = PostService();

  RxList posts = <PostModel>[].obs; // Correct naming convention
  RxBool isLoading = false.obs;
  Rx<PostModel?> selectedPost = Rx(null);

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      final fetchedPosts = await postService.fetchPosts(); // Use the instance
      posts.value = fetchedPosts;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les événements');
    } finally {
      isLoading.value = false;
    }
  }


}
