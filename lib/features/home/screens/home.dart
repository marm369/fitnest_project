import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_scroll_widget.dart';
import '../../../common/widgets/tabbutton/tab_item.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/home_controller.dart';
import '../models/post_model.dart';
import 'widgets/components/post_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate controllers
    final HomeController homeController = Get.put(HomeController());

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
                  SizedBox(
                    height: 60,
                    child: Obx(
                      () => ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.categories.length,
                        itemBuilder: (context, index) {
                          final category = homeController.categories[index];
                          final interest = category['name'];
                          final iconData =
                              category['icon']; // Récupérez l'icône ici

                          return GestureDetector(
                            onTap: () =>
                                homeController.toggleCategory(interest),
                            child: Row(
                              children: [
                                TabItem(
                                  text: interest,
                                  icon: Icon(
                                    iconData,
                                    color: homeController
                                                .selectedCategorie[interest] ==
                                            true
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(width: MySizes.spaceBtwItems),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MySizes.xs),
                  EventScrollWidget(),
                ],
              ),
            ),
          ];
        },
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: MySizes.sm),
          itemBuilder: (context, index) {
            return PostCard(
              post: dummyPosts[index],
              onTap: () {},
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: dummyPosts.length,
        ),
      ),
    );
  }
}
