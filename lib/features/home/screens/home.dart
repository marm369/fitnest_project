import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_scroll_widget.dart';
import '../../../common/widgets/tabbutton/tab_item.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/home_controller.dart';
import '../controllers/PostController.dart';
import 'widgets/components/post_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate controllers
    final HomeController homeController = Get.put(HomeController());
    final PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              pinned: false,
              elevation: 0,
              title: Obx(() {
                final userName = homeController.userName.value;
                return Text(
                  'Hi $userName,',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: MySizes.defaultSpace / 2),
                  Obx(
                        () => SizedBox(
                      height: 60,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.categories.length,
                        itemBuilder: (context, index) {
                          final interest =
                          homeController.categories[index]['name'];
                          return Obx(() => GestureDetector(
                            onTap: () =>
                                homeController.toggleCategory(interest),
                            child: Row(
                              children: [
                                TabItem(
                                  text: interest,
                                  icon: Icon(
                                    homeController.categories[index]
                                    ['icon'],
                                    color: homeController.selectedCategorie[
                                    interest] ==
                                        true
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(width: MySizes.spaceBtwItems),
                              ],
                            ),
                          ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MySizes.xs),
                  EventScrollWidget(),
                  SizedBox(height: MySizes.sm),
                ],
              ),
            ),
          ];
        },
        body: Obx(() {
          if (postController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (postController.posts.isEmpty) {
            return const Center(
              child: Text('Aucun post disponible.'),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: MySizes.sm),
              itemBuilder: (context, index) {
                final post = postController.posts[index];
                return PostCard(
                  post: post, // Utilisation des données dynamiques
                  onTap: () {
                    // Action lorsque l'utilisateur clique sur un post
                    Get.snackbar('Post sélectionné', post.name);
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: postController.posts.length,
            );
          }
        }),
      ),
    );
  }
}
