import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../../../common/widgets/cards/event_scroll_widget.dart';
import '../../../common/widgets/tabbutton/tab_item.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/controllers/signup/signup_controller.dart';
import '../controllers/home_controller.dart';
import '../enums/post_type.dart';
import '../models/post_model.dart';
import 'widgets/components/custom_icons.dart';
import 'widgets/components/post_card.dart';
import 'widgets/components/post_type_chips.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate controllers
    final HomeController controller1 = Get.put(HomeController());
    final SignupController controller2 = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Text(
              'Hi ${controller1.userName.value},',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: CustomIcons(
              src: MyImages.kChat,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MySizes.defaultSpace),
          // Interests Horizontal Scrollable List
          Obx(
            () => Flexible(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16), // Apply horizontal padding
                  scrollDirection: Axis.horizontal,
                  itemCount: controller2.interests.length,
                  itemBuilder: (context, index) {
                    final interest = controller2.interests[index]['name'];
                    final isSelected =
                        controller2.selectedInterests[interest] ?? false;
                    final iconData = controller2.interests[index]['icon'];
                    return GestureDetector(
                      onTap: () => controller2.toggleInterest(interest),
                      child: Row(
                        children: [
                          TabItem(
                            text: interest,
                            icon: Icon(
                              iconData,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                          SizedBox(
                              width:
                                  MySizes.spaceBtwItems), // Space between items
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          EventScrollWidget(),
          Expanded(
            // Main content area with animations and scrollable list
            child: ListView(
              children: [
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
        ],
      ),
    );
  }
}
