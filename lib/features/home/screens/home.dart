import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/tabbutton/tab_item.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../notification/screens/notification_screen.dart';
import '../controllers/home_controller.dart';
import '../controllers/post_controller.dart';
import 'event_scroll_widget.dart';
import 'widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool dark = HelperFunctions.isDarkMode(context);
    // Instantiate controllers
    final HomeController homeController = Get.put(HomeController());
    final PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: dark ? Colors.black : Colors.white,
              floating: true,
              pinned: false,
              elevation: 0,
              title: Obx(() {
                final userName = homeController.userName.value;
                return Text(
                  'Hi $userName,',
                  style: TextStyle(
                      fontSize: 18, color: dark ? Colors.white : Colors.black),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Naviguer vers la page de notifications
                      Get.to(() => NotificationScreen());
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications,
                          size: MySizes.iconLg,
                          color: dark ? Colors.white : Colors.black,
                        ),
                        Positioned(
                          top: -5,
                          right: 16,
                          child: 8 > 0
                              ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "8",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(
                        () => Container(
                      color: dark
                          ? Colors.black
                          : Colors
                          .white, // Couleur d'arrière-plan selon le mode
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
                  EventScrollWidget(),
                ],
              ),
            ),
          ];
        },
        body: Container(
          color: dark
              ? Colors.black
              : Colors.white, // Définir la couleur de fond ici
          child: Obx(() {
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
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemCount: postController.posts.length,
              );
            }
          }),
        ),
      ),
    );
  }
}