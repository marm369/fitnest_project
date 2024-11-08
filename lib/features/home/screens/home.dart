import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../../../utils/constants/image_strings.dart';
import '../controllers/home_controller.dart';
import '../enums/post_type.dart';
import '../models/post_model.dart';
import 'widgets/components/custom_icons.dart';
import 'widgets/components/post_card.dart';
import 'widgets/components/post_type_chips.dart'; // Assurez-vous d'importer le contrôleur

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instancier le contrôleur
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              'Hi ${controller.userName.value},', // Afficher le nom réel
              style: const TextStyle(fontSize: 18, color: Colors.black),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomIcons(
              src: MyImages.kHeart,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: CustomIcons(
              src: MyImages.kChat,
            ),
          ),
        ],
      ),
      body: AnimationLimiter(
        child: ListView(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: MediaQuery.of(context).size.width / 2,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 30,
                child: ListView.separated(
                  itemCount: PostType.values.length,
                  padding: const EdgeInsets.only(left: 24),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    PostTypeChips(
                      isSelected: true,
                      /* controller.selectedPostType.value == index,*/
                      onTap: () {
                        //controller.changePostType(index);
                      },
                      postType: PostType.values[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return PostCard(
                    post: dummyPosts[index],
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: dummyPosts.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
